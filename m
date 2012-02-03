From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 2/3] Btrfs-progs: implement new subcommand parser
Date: Fri,  3 Feb 2012 23:23:59 +0200
Message-ID: <1328304240-26100-3-git-send-email-idryomov@gmail.com>
References: <1328304240-26100-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1328304240-26100-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This completely replaces the existing subcommand infrastructure, which
is not flexible enough to accomodate our needs.  Instead of a global
command table we now have per-level tables and command group handlers,
which allows command-group-specific handling of options and subcommands.
The new parser exports a clear interface and gets out of the way - all
control over how matching is done is passed to commands and command
group handlers.

One side effect of this is that command implementors have to check the
number of arguments themselves - patch to fix up all existing commands
follows.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 Makefile   |    4 +-
 btrfs.c    |  574 ++++++++++++++++++++----------------------------------------
 commands.h |   80 +++++++++
 help.c     |  207 ++++++++++++++++++++++
 4 files changed, 479 insertions(+), 386 deletions(-)
 create mode 100644 commands.h
 create mode 100644 help.c

diff --git a/Makefile b/Makefile
index 0d47bd5..deafda6 100644
--- a/Makefile
+++ b/Makefile
@@ -38,8 +38,8 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o common.o $(cmds_objects)
-	$(CC) $(CFLAGS) -o btrfs btrfs.o common.o $(cmds_objects) \
+btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects)
+	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 calc-size: $(objects) calc-size.o
diff --git a/btrfs.c b/btrfs.c
index 1def354..7cff30b 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -19,444 +19,250 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "kerncompat.h"
-#include "btrfs_cmds.h"
+#include "commands.h"
 #include "version.h"
 
-#define BASIC_HELP 0
-#define ADVANCED_HELP 1
-
-typedef int (*CommandFunction)(int argc, char **argv);
-
-struct Command {
-	CommandFunction	func;	/* function which implements the command */
-	int	nargs;		/* if == 999, any number of arguments
-				   if >= 0, number of arguments,
-				   if < 0, _minimum_ number of arguments */
-	char	*verb;		/* verb */
-	char	*help;		/* help lines; from the 2nd line onward they 
-                                   are automatically indented */
-        char    *adv_help;      /* advanced help message; from the 2nd line 
-                                   onward they are automatically indented */
-
-	/* the following fields are run-time filled by the program */
-	char	**cmds;		/* array of subcommands */
-	int	ncmds;		/* number of subcommand */
-};
+static const char btrfs_cmd_group_usage[] =
+	"btrfs [--help] [--version] <group> [<group>...] <command> [<args>]";
 
-static struct Command commands[] = {
+static const char btrfs_cmd_group_info[] =
+	"Use --help as an argument for information on a specific group or command.";
 
-	/*
-		avoid short commands different for the case only
-	*/
-	{ do_clone, -2,
-	  "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
-		"Create a writable/readonly snapshot of the subvolume <source> with\n"
-		"the name <name> in the <dest> directory.",
-	  NULL
-	},
-	{ do_delete_subvolume, 1,
-	  "subvolume delete", "<subvolume>\n"
-		"Delete the subvolume <subvolume>.",
-	  NULL
-	},
-	{ do_create_subvol, 1,
-	  "subvolume create", "[<dest>/]<name>\n"
-		"Create a subvolume in <dest> (or the current directory if\n"
-		"not passed).",
-	  NULL
-	},
-	{ do_subvol_list, -1, "subvolume list", "[-p] <path>\n"
-		"List the snapshot/subvolume of a filesystem.",
-		"[-p] <path>\n"
-		"List the snapshot/subvolume of a filesystem.\n"
-		"-p	   print parent ID"
-	},
-	{ do_set_default_subvol, 2,
-	  "subvolume set-default", "<id> <path>\n"
-		"Set the subvolume of the filesystem <path> which will be mounted\n"
-		"as default.",
-	  NULL
-	},
-	{ do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
-		"List the recently modified files in a filesystem.",
-	  NULL
-	},
-	{ do_defrag, -1,
-	  "filesystem defragment", "[-vf] [-c[zlib,lzo]] [-s start] [-l len] [-t size] <file>|<dir> [<file>|<dir>...]\n"
-		"Defragment a file or a directory.",
-	  	"[-vcf] [-s start] [-l len] [-t size] <file>|<dir> [<file>|<dir>...]\n"
-		"Defragment file data or directory metadata.\n"
-		"-v         be verbose\n"
-		"-c         compress the file while defragmenting\n"
-		"-f         flush data to disk immediately after defragmenting\n"
-		"-s start   defragment only from byte onward\n"
-		"-l len     defragment only up to len bytes\n"
-		"-t size    minimal size of file to be considered for defragmenting\n"
-	},
-	{ do_get_default_subvol, 1, "subvolume get-default", "<path>\n"
-		"Get the default subvolume of a filesystem."
-	},
-	{ do_fssync, 1,
-	  "filesystem sync", "<path>\n"
-		"Force a sync on the filesystem <path>.",
-	  NULL
-	},
-	{ do_resize, 2,
-	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
-		"Resize the file system. If 'max' is passed, the filesystem\n"
-		"will occupe all available space on the device.",
-	  NULL
-	},
-	{ do_show_filesystem, 999,
-	  "filesystem show", "[--all-devices][<uuid>|<label>]\n"
-		"Show the info of a btrfs filesystem. If no argument\n"
-		"is passed, info of all the btrfs filesystem are shown.",
-	  NULL
-	},
-	{ do_df_filesystem, 1,
-	  "filesystem df", "<path>\n"
-		"Show space usage information for a mount point.",
-	  NULL
-	},
-	{ do_balance, 1,
-	  "filesystem balance", "<path>\n"
-		"Balance the chunks across the device.",
-	  NULL
-	},
-	{ do_change_label, -1,
-	  "filesystem label", "<device> [<newlabel>]\n"
-	  "With one argument, get the label of filesystem on <device>.\n"
-	  "If <newlabel> is passed, set the filesystem label to <newlabel>.\n"
-	  "The filesystem must be unmounted.\n"
-	},
-	{ do_scrub_start, -1,
-	  "scrub start", "[-Bdqr] <path>|<device>\n"
-		"Start a new scrub.",
-		"\n-B  do not background\n"
-		"-d  stats per device (-B only)\n"
-		"-q  quiet\n"
-		"-r  read only mode\n"
-	},
-	{ do_scrub_cancel, 1,
-	  "scrub cancel", "<path>|<device>\n"
-		"Cancel a running scrub.",
-	  NULL
-	},
-	{ do_scrub_resume, -1,
-	  "scrub resume", "[-Bdqr] <path>|<device>\n"
-		"Resume previously canceled or interrupted scrub.",
-	  NULL
-	},
-	{ do_scrub_status, -1,
-	  "scrub status", "[-d] <path>|<device>\n"
-		"Show status of running or finished scrub.",
-	  NULL
-	},
-	{ do_scan, 999, 
-	  "device scan", "[<device>...]\n"
-		"Scan all device for or the passed device for a btrfs\n"
-		"filesystem.",
-	  NULL
-	},
-	{ do_add_volume, -2,
-	  "device add", "<device> [<device>...] <path>\n"
-		"Add a device to a filesystem.",
-	  NULL
-	},
-	{ do_remove_volume, -2,
-	  "device delete", "<device> [<device>...] <path>\n"
-		"Remove a device from a filesystem.",
-	  NULL
-	},
-	{ do_ino_to_path, -2,
-	  "inspect-internal inode-resolve", "[-v] <inode> <path>\n"
-		"get file system paths for the given inode.",
-	  NULL
-	},
-	{ do_logical_to_ino, -2,
-	  "inspect-internal logical-resolve", "[-v] [-P] <logical> <path>\n"
-		"get file system paths for the given logical address.",
-	  NULL
-	},
-	{ 0, 0, 0, 0 }
-};
+char argv0_buf[ARGV0_BUF_SIZE] = "btrfs";
 
-static char *get_prgname(char *programname)
+static inline const char *skip_prefix(const char *str, const char *prefix)
 {
-	char	*np;
-	np = strrchr(programname,'/');
-	if(!np)
-		np = programname;
-	else
-		np++;
-
-	return np;
+	size_t len = strlen(prefix);
+	return strncmp(str, prefix, len) ? NULL : str + len;
 }
 
-static void print_help(char *programname, struct Command *cmd, int helptype)
+int prefixcmp(const char *str, const char *prefix)
 {
-	char	*pc;
-
-	printf("\t%s %s ", programname, cmd->verb );
+	for (; ; str++, prefix++)
+		if (!*prefix)
+			return 0;
+		else if (*str != *prefix)
+			return (unsigned char)*prefix - (unsigned char)*str;
+}
 
-	if (helptype == ADVANCED_HELP && cmd->adv_help)
-		for(pc = cmd->adv_help; *pc; pc++){
-			putchar(*pc);
-			if(*pc == '\n')
-				printf("\t\t");
-		}
-	else
-		for(pc = cmd->help; *pc; pc++){
-			putchar(*pc);
-			if(*pc == '\n')
-				printf("\t\t");
+static int parse_one_token(const char *arg, const struct cmd_group *grp,
+			   const struct cmd_struct **cmd_ret)
+{
+	const struct cmd_struct *cmd = grp->commands;
+	const struct cmd_struct *abbrev_cmd = NULL, *ambiguous_cmd = NULL;
+
+	for (; cmd->token; cmd++) {
+		const char *rest;
+
+		rest = skip_prefix(arg, cmd->token);
+		if (!rest) {
+			if (!prefixcmp(cmd->token, arg)) {
+				if (abbrev_cmd) {
+					/*
+					 * If this is abbreviated, it is
+					 * ambiguous. So when there is no
+					 * exact match later, we need to
+					 * error out.
+					 */
+					ambiguous_cmd = abbrev_cmd;
+				}
+				abbrev_cmd = cmd;
+			}
+			continue;
 		}
+		if (*rest)
+			continue;
 
-	putchar('\n');
-}
+		*cmd_ret = cmd;
+		return 0;
+	}
 
-static void help(char *np)
-{
-	struct Command *cp;
+	if (ambiguous_cmd)
+		return -2;
 
-	printf("Usage:\n");
-	for( cp = commands; cp->verb; cp++ )
-		print_help(np, cp, BASIC_HELP);
+	if (abbrev_cmd) {
+		*cmd_ret = abbrev_cmd;
+		return 0;
+	}
 
-	printf("\n\t%s help|--help|-h\n\t\tShow the help.\n",np);
-	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a command or\n\t\t"
-	       "subset of commands.\n",np);
-	printf("\n%s\n", BTRFS_BUILD_VERSION);
+	return -1;
 }
 
-static int split_command(char *cmd, char ***commands)
+static const struct cmd_struct *
+parse_command_token(const char *arg, const struct cmd_group *grp)
 {
-	int	c, l;
-	char	*p, *s;
+	const struct cmd_struct *cmd;
 
-	for( *commands = 0, l = c = 0, p = s = cmd ; ; p++, l++ ){
-		if ( *p && *p != ' ' )
-			continue;
-
-		/* c + 2 so that we have room for the null */
-		(*commands) = realloc( (*commands), sizeof(char *)*(c + 2));
-		(*commands)[c] = strndup(s, l);
-		c++;
-		l = 0;
-		s = p+1;
-		if( !*p ) break;
+	switch(parse_one_token(arg, grp, &cmd)) {
+	case -1:
+		help_unknown_token(arg, grp);
+	case -2:
+		help_ambiguous_token(arg, grp);
 	}
 
-	(*commands)[c] = 0;
-	return c;
+	return cmd;
 }
 
-/*
-	This function checks if the passed command is ambiguous
-*/
-static int check_ambiguity(struct Command *cmd, char **argv){
-	int		i;
-	struct Command	*cp;
-	/* check for ambiguity */
-	for( i = 0 ; i < cmd->ncmds ; i++ ){
-		int match;
-		for( match = 0, cp = commands; cp->verb; cp++ ){
-			int	j, skip;
-			char	*s1, *s2;
-
-			if( cp->ncmds < i )
-				continue;
-
-			for( skip = 0, j = 0 ; j < i ; j++ )
-				if( strcmp(cmd->cmds[j], cp->cmds[j])){
-					skip=1;
-					break;
-				}
-			if(skip)
-				continue;
-
-			if( !strcmp(cmd->cmds[i], cp->cmds[i]))
-				continue;
-			for(s2 = cp->cmds[i], s1 = argv[i+1];
-				*s1 == *s2 && *s1; s1++, s2++ ) ;
-			if( !*s1 )
-				match++;
-		}
-		if(match){
-			int j;
-			fprintf(stderr, "ERROR: in command '");
-			for( j = 0 ; j <= i ; j++ )
-				fprintf(stderr, "%s%s",j?" ":"", argv[j+1]);
-			fprintf(stderr, "', '%s' is ambiguous\n",argv[j]);
-			return -2;
+void handle_help_options_next_level(const struct cmd_struct *cmd,
+				    int argc, char **argv)
+{
+	if (argc < 2)
+		return;
+
+	if (!strcmp(argv[1], "--help")) {
+		if (cmd->next) {
+			argc--;
+			argv++;
+			help_command_group(cmd->next, argc, argv);
+		} else {
+			usage_command(cmd, 1, 0);
 		}
+
+		exit(0);
 	}
-	return 0;
 }
 
-/*
- * This function, compacts the program name and the command in the first
- * element of the '*av' array
- */
-static int prepare_args(int *ac, char ***av, char *prgname, struct Command *cmd ){
-
-	char	**ret;
-	int	i;
-	char	*newname;
-
-	ret = (char **)malloc(sizeof(char*)*(*ac+1));
-	newname = (char*)malloc(strlen(prgname)+strlen(cmd->verb)+2);
-	if( !ret || !newname ){
-		free(ret);
-		free(newname);
-		return -1;
-	}
+static void fixup_argv0(char **argv, const char *token)
+{
+	int len = strlen(argv0_buf);
 
-	ret[0] = newname;
-	for(i=0; i < *ac ; i++ )
-		ret[i+1] = (*av)[i];
+	snprintf(argv0_buf + len, sizeof(argv0_buf) - len, " %s", token);
+	argv[0] = argv0_buf;
+}
 
-	strcpy(newname, prgname);
-	strcat(newname, " ");
-	strcat(newname, cmd->verb);
+int handle_command_group(const struct cmd_group *grp, int argc,
+			 char **argv)
 
-	(*ac)++;
-	*av = ret;
+{
+	const struct cmd_struct *cmd;
 
-	return 0;
+	argc--;
+	argv++;
+	if (argc < 1) {
+		usage_command_group(grp, 0, 0);
+		exit(1);
+	}
 
+	cmd = parse_command_token(argv[0], grp);
+
+	handle_help_options_next_level(cmd, argc, argv);
+
+	fixup_argv0(argv, cmd->token);
+	return cmd->fn(argc, argv);
 }
 
+int check_argc_exact(int nargs, int expected)
+{
+	if (nargs < expected)
+		fprintf(stderr, "%s: too few arguments\n", argv0_buf);
+	if (nargs > expected)
+		fprintf(stderr, "%s: too many arguments\n", argv0_buf);
 
+	return nargs != expected;
+}
 
-/*
-	This function performs the following jobs:
-	- show the help if '--help' or 'help' or '-h' are passed
-	- verify that a command is not ambiguous, otherwise show which
-	  part of the command is ambiguous
-	- if after a (even partial) command there is '--help' show detailed help
-	  for all the matching commands
-	- if the command doesn't match show an error
-	- finally, if a command matches, they return which command matched and
-	  the arguments
-
-	The function return 0 in case of help is requested; <0 in case
-	of uncorrect command; >0 in case of matching commands
-	argc, argv are the arg-counter and arg-vector (input)
-	*nargs_ is the number of the arguments after the command (output)
-	**cmd_  is the invoked command (output)
-	***args_ are the arguments after the command
-
-*/
-static int parse_args(int argc, char **argv,
-		      CommandFunction *func_,
-		      int *nargs_, char **cmd_, char ***args_ )
+int check_argc_min(int nargs, int expected)
 {
-	struct Command	*cp;
-	struct Command	*matchcmd=0;
-	char		*prgname = get_prgname(argv[0]);
-	int		i=0, helprequested=0;
-
-	if( argc < 2 || !strcmp(argv[1], "help") ||
-		!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help")){
-		help(prgname);
-		return 0;
+	if (nargs < expected) {
+		fprintf(stderr, "%s: too few arguments\n", argv0_buf);
+		return 1;
 	}
 
-	for( cp = commands; cp->verb; cp++ )
-		if( !cp->ncmds)
-			cp->ncmds = split_command(cp->verb, &(cp->cmds));
+	return 0;
+}
 
-	for( cp = commands; cp->verb; cp++ ){
-		int     match;
+int check_argc_max(int nargs, int expected)
+{
+	if (nargs > expected) {
+		fprintf(stderr, "%s: too many arguments\n", argv0_buf);
+		return 1;
+	}
 
-		if( argc-1 < cp->ncmds )
-			continue;
-		for( match = 1, i = 0 ; i < cp->ncmds ; i++ ){
-			char	*s1, *s2;
-			s1 = cp->cmds[i];
-			s2 = argv[i+1];
-
-			for(s2 = cp->cmds[i], s1 = argv[i+1];
-				*s1 == *s2 && *s1;
-				s1++, s2++ ) ;
-			if( *s1 ){
-				match=0;
-				break;
-			}
-		}
+	return 0;
+}
 
-		/* If you understand why this code works ...
-			you are a genious !! */
-		if(argc>i+1 && !strcmp(argv[i+1],"--help")){
-			if(!helprequested)
-				printf("Usage:\n");
-			print_help(prgname, cp, ADVANCED_HELP);
-			helprequested=1;
-			continue;
-		}
+const struct cmd_group btrfs_cmd_group;
 
-		if(!match)
-			continue;
-
-		matchcmd = cp;
-		*nargs_  = argc-matchcmd->ncmds-1;
-		*cmd_ = matchcmd->verb;
-		*args_ = argv+matchcmd->ncmds+1;
-		*func_ = cp->func;
+static const char * const cmd_help_usage[] = {
+	"btrfs help [--full]",
+	"Dislay help information",
+	"",
+	"--full     display detailed help on every command",
+	NULL
+};
 
-		break;
-	}
+static int cmd_help(int argc, char **argv)
+{
+	help_command_group(&btrfs_cmd_group, argc, argv);
+	return 0;
+}
 
-	if(helprequested){
-		printf("\n%s\n", BTRFS_BUILD_VERSION);
-		return 0;
-	}
+static const char * const cmd_version_usage[] = {
+	"btrfs version",
+	"Display btrfs-progs version",
+	NULL
+};
 
-	if(!matchcmd){
-		fprintf( stderr, "ERROR: unknown command '%s'\n",argv[1]);
-		help(prgname);
-		return -1;
-	}
+static int cmd_version(int argc, char **argv)
+{
+	printf("%s\n", BTRFS_BUILD_VERSION);
+	return 0;
+}
 
-	if(check_ambiguity(matchcmd, argv))
-		return -2;
+static int handle_options(int *argc, char ***argv)
+{
+	char **orig_argv = *argv;
+
+	while (*argc > 0) {
+		const char *arg = (*argv)[0];
+		if (arg[0] != '-')
+			break;
+
+		if (!strcmp(arg, "--help")) {
+			break;
+		} else if (!strcmp(arg, "--version")) {
+			break;
+		} else {
+			fprintf(stderr, "Unknown option: %s\n", arg);
+			fprintf(stderr, "usage: %s\n",
+				btrfs_cmd_group.usagestr);
+			exit(129);
+		}
 
-	/* check the number of argument */
-	if (matchcmd->nargs < 0 && matchcmd->nargs < -*nargs_ ){
-		fprintf(stderr, "ERROR: '%s' requires minimum %d arg(s)\n",
-			matchcmd->verb, -matchcmd->nargs);
-			return -2;
-	}
-	if(matchcmd->nargs >= 0 && matchcmd->nargs != *nargs_ && matchcmd->nargs != 999){
-		fprintf(stderr, "ERROR: '%s' requires %d arg(s)\n",
-			matchcmd->verb, matchcmd->nargs);
-			return -2;
+		(*argv)++;
+		(*argc)--;
 	}
-	
-        if (prepare_args( nargs_, args_, prgname, matchcmd )){
-                fprintf(stderr, "ERROR: not enough memory\\n");
-		return -20;
-        }
-
 
-	return 1;
+	return (*argv) - orig_argv;
 }
-int main(int ac, char **av )
-{
 
-	char		*cmd=0, **args=0;
-	int		nargs=0, r;
-	CommandFunction func=0;
+const struct cmd_group btrfs_cmd_group = {
+	btrfs_cmd_group_usage, btrfs_cmd_group_info, {
+		{ "help", cmd_help, cmd_help_usage, NULL, 0 },
+		{ "version", cmd_version, cmd_version_usage, NULL, 0 },
+		{ 0, 0, 0, 0, 0 }
+	},
+};
 
-	r = parse_args(ac, av, &func, &nargs, &cmd, &args);
-	if( r <= 0 ){
-		/* error or no command to parse*/
-		exit(-r);
+int main(int argc, char **argv)
+{
+	const struct cmd_struct *cmd;
+
+	argc--;
+	argv++;
+	handle_options(&argc, &argv);
+	if (argc > 0) {
+		if (!prefixcmp(argv[0], "--"))
+			argv[0] += 2;
+	} else {
+		usage_command_group(&btrfs_cmd_group, 0, 0);
+		exit(1);
 	}
 
-	exit(func(nargs, args));
+	cmd = parse_command_token(argv[0], &btrfs_cmd_group);
 
-}
+	handle_help_options_next_level(cmd, argc, argv);
 
+	fixup_argv0(argv, cmd->token);
+	exit(cmd->fn(argc, argv));
+}
diff --git a/commands.h b/commands.h
new file mode 100644
index 0000000..092b368
--- /dev/null
+++ b/commands.h
@@ -0,0 +1,80 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#define ARGV0_BUF_SIZE	64
+
+struct cmd_struct {
+	const char *token;
+	int (*fn)(int, char **);
+
+	/*
+	 * Usage strings
+	 *
+	 * A NULL-terminated array of the following format:
+	 *
+	 *   usagestr[0] - one-line synopsis (required)
+	 *   usagestr[1] - one-line short description (required)
+	 *   usagestr[2..m] - a long (possibly multi-line) description
+	 *                    (optional)
+	 *   usagestr[m + 1] - an empty line separator (required if at least one
+	 *                     option string is given, not needed otherwise)
+	 *   usagestr[m + 2..n] - option strings, one option per line
+	 *                        (optional)
+	 *   usagestr[n + 1] - NULL terminator
+	 *
+	 * Options (if present) should always (even if there is no long
+	 * description) be prepended with an empty line.  Supplied strings are
+	 * indented but otherwise printed as-is, no automatic wrapping is done.
+	 *
+	 * Grep for cmd_*_usage[] for examples.
+	 */
+	const char * const *usagestr;
+
+	/* should be NULL if token is not a subgroup */
+	const struct cmd_group *next;
+
+	/* if true don't list this token in help listings */
+	int hidden;
+};
+
+struct cmd_group {
+	const char *usagestr;
+	const char *infostr;
+
+	const struct cmd_struct commands[];
+};
+
+/* btrfs.c */
+int prefixcmp(const char *str, const char *prefix);
+
+int check_argc_exact(int nargs, int expected);
+int check_argc_min(int nargs, int expected);
+int check_argc_max(int nargs, int expected);
+
+int handle_command_group(const struct cmd_group *grp, int argc,
+			 char **argv);
+
+/* help.c */
+extern const char * const generic_cmd_help_usage[];
+
+void usage(const char * const *usagestr);
+void usage_command(const struct cmd_struct *cmd, int full, int err);
+void usage_command_group(const struct cmd_group *grp, int all, int err);
+
+void help_unknown_token(const char *arg, const struct cmd_group *grp);
+void help_ambiguous_token(const char *arg, const struct cmd_group *grp);
+
+void help_command_group(const struct cmd_group *grp, int argc, char **argv);
diff --git a/help.c b/help.c
new file mode 100644
index 0000000..932bdf2
--- /dev/null
+++ b/help.c
@@ -0,0 +1,207 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "commands.h"
+
+extern char argv0_buf[ARGV0_BUF_SIZE];
+
+#define USAGE_SHORT		1U
+#define USAGE_LONG		2U
+#define USAGE_OPTIONS		4U
+#define USAGE_LISTING		8U
+
+static int do_usage_one_command(const char * const *usagestr,
+				unsigned int flags, FILE *outf)
+{
+	int pad = 4;
+
+	if (!usagestr || !*usagestr)
+		return -1;
+
+	fprintf(outf, "%s%s\n", (flags & USAGE_LISTING) ? "    " : "usage: ",
+		*usagestr++);
+
+	/* a short one-line description (mandatory) */
+	if ((flags & USAGE_SHORT) == 0)
+		return 0;
+	else if (!*usagestr)
+		return -2;
+
+	if (flags & USAGE_LISTING)
+		pad = 8;
+	else
+		fputc('\n', outf);
+
+	fprintf(outf, "%*s%s\n", pad, "", *usagestr++);
+
+	/* a long (possibly multi-line) description (optional) */
+	if (!*usagestr || ((flags & USAGE_LONG) == 0))
+		return 0;
+
+	if (**usagestr)
+		fputc('\n', outf);
+	while (*usagestr && **usagestr)
+		fprintf(outf, "%*s%s\n", pad, "", *usagestr++);
+
+	/* options (optional) */
+	if (!*usagestr || ((flags & USAGE_OPTIONS) == 0))
+		return 0;
+
+	/*
+	 * options (if present) should always (even if there is no long
+	 * description) be prepended with an empty line, skip it
+	 */
+	usagestr++;
+
+	fputc('\n', outf);
+	while (*usagestr)
+		fprintf(outf, "%*s%s\n", pad, "", *usagestr++);
+
+	return 0;
+}
+
+static int usage_command_internal(const char * const *usagestr,
+				  const char *token, int full, int lst,
+				  FILE *outf)
+{
+	unsigned int flags = USAGE_SHORT;
+	int ret;
+
+	if (full)
+		flags |= USAGE_LONG | USAGE_OPTIONS;
+	if (lst)
+		flags |= USAGE_LISTING;
+
+	ret = do_usage_one_command(usagestr, flags, outf);
+	switch (ret) {
+	case -1:
+		fprintf(outf, "No usage for '%s'\n", token);
+		break;
+	case -2:
+		fprintf(outf, "No short description for '%s'\n", token);
+		break;
+	}
+
+	return ret;
+}
+
+static void usage_command_usagestr(const char * const *usagestr,
+				   const char *token, int full, int err)
+{
+	FILE *outf = err ? stderr : stdout;
+	int ret;
+
+	ret = usage_command_internal(usagestr, token, full, 0, outf);
+	if (!ret)
+		fputc('\n', outf);
+}
+
+void usage_command(const struct cmd_struct *cmd, int full, int err)
+{
+	usage_command_usagestr(cmd->usagestr, cmd->token, full, err);
+}
+
+void usage(const char * const *usagestr)
+{
+	usage_command_usagestr(usagestr, NULL, 1, 1);
+	exit(129);
+}
+
+static void usage_command_group_internal(const struct cmd_group *grp, int full,
+					 FILE *outf)
+{
+	const struct cmd_struct *cmd = grp->commands;
+	int do_sep = 0;
+
+	for (; cmd->token; cmd++) {
+		if (cmd->hidden)
+			continue;
+
+		if (full && cmd != grp->commands)
+			fputc('\n', outf);
+
+		if (!cmd->next) {
+			if (do_sep) {
+				fputc('\n', outf);
+				do_sep = 0;
+			}
+
+			usage_command_internal(cmd->usagestr, cmd->token, full,
+					       1, outf);
+			continue;
+		}
+
+		/* this is an entry point to a nested command group */
+
+		if (!full && cmd != grp->commands)
+			fputc('\n', outf);
+
+		usage_command_group_internal(cmd->next, full, outf);
+
+		if (!full)
+			do_sep = 1;
+	}
+}
+
+void usage_command_group(const struct cmd_group *grp, int full, int err)
+{
+	FILE *outf = err ? stderr : stdout;
+
+	fprintf(outf, "usage: %s\n\n", grp->usagestr);
+	usage_command_group_internal(grp, full, outf);
+	fputc('\n', outf);
+
+	if (grp->infostr)
+		fprintf(outf, "%s\n", grp->infostr);
+}
+
+void help_unknown_token(const char *arg, const struct cmd_group *grp)
+{
+	fprintf(stderr, "%s: unknown token '%s'\n", argv0_buf, arg);
+	usage_command_group(grp, 0, 1);
+	exit(1);
+}
+
+void help_ambiguous_token(const char *arg, const struct cmd_group *grp)
+{
+	const struct cmd_struct *cmd = grp->commands;
+
+	fprintf(stderr, "%s: ambiguous token '%s'\n", argv0_buf, arg);
+	fprintf(stderr, "\nDid you mean one of these ?\n");
+
+	for (; cmd->token; cmd++) {
+		if (!prefixcmp(cmd->token, arg))
+			fprintf(stderr, "\t%s\n", cmd->token);
+	}
+
+	exit(1);
+}
+
+void help_command_group(const struct cmd_group *grp, int argc, char **argv)
+{
+	int full = 0;
+
+	if (argc > 1) {
+		if (!strcmp(argv[1], "--full"))
+			full = 1;
+	}
+
+	usage_command_group(grp, full, 0);
+}
-- 
1.7.6.3

