From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH 2/2] add detailed help messages to btrfs command
Date: Sun, 23 Jan 2011 13:42:43 +0100
Message-ID: <201101231342.43637.kario@wit.edu.pl>
References: <201101231339.36599.kario@wit.edu.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101231339.36599.kario@wit.edu.pl>
List-ID: <linux-btrfs.vger.kernel.org>

extend the

        btrfs <cmd> --help

command to print detailed help message if available but fallback to
basic help message if detailed is unavailable

add detailed help message for 'filesystem defragment' command

little tweaks in comments

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
 btrfs.c |  101 ++++++++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 68 insertions(+), 33 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index b84607a..bd6f6f8 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -23,6 +23,9 @@
 #include "btrfs_cmds.h"
 #include "version.h"
 
+#define BASIC_HELP 0
+#define ADVANCED_HELP 1
+
 typedef int (*CommandFunction)(int argc, char **argv);
 
 struct Command {
@@ -31,8 +34,10 @@ struct Command {
 				   if >= 0, number of arguments,
 				   if < 0, _minimum_ number of arguments */
 	char	*verb;		/* verb */
-	char	*help;		/* help lines; form the 2nd onward they are
-				   indented */
+	char	*help;		/* help lines; from the 2nd line onward they 
+                                   are automatically indented */
+        char    *adv_help;      /* advanced help message; from the 2nd line 
+                                   onward they are automatically indented */
 
 	/* the following fields are run-time filled by the program */
 	char	**cmds;		/* array of subcommands */
@@ -47,73 +52,96 @@ static struct Command commands[] = {
 	{ do_clone, 2,
 	  "subvolume snapshot", "<source> [<dest>/]<name>\n"
 		"Create a writable snapshot of the subvolume <source> with\n"
-		"the name <name> in the <dest> directory."
+		"the name <name> in the <dest> directory.",
+          NULL
 	},
 	{ do_delete_subvolume, 1,
 	  "subvolume delete", "<subvolume>\n"
-		"Delete the subvolume <subvolume>."
+		"Delete the subvolume <subvolume>.",
+          NULL
 	},
 	{ do_create_subvol, 1,
 	  "subvolume create", "[<dest>/]<name>\n"
 		"Create a subvolume in <dest> (or the current directory if\n"
-		"not passed)."
+		"not passed).",
+          NULL
 	},
 	{ do_subvol_list, 1, "subvolume list", "<path>\n"
-		"List the snapshot/subvolume of a filesystem."
+		"List the snapshot/subvolume of a filesystem.",
+          NULL
 	},
 	{ do_find_newer, 2, "subvolume find-new", "<path> <last_gen>\n"
-		"List the recently modified files in a filesystem."
+		"List the recently modified files in a filesystem.",
+          NULL
 	},
 	{ do_defrag, -1,
 	  "filesystem defragment", "[-vcf] [-s start] [-l len] [-t size] <file>|<dir> [<file>|<dir>...]\n"
-		"Defragment a file or a directory."
+		"Defragment a file or a directory.",
+          "[-vcf] [-s start] [-l len] [-t size] <file>|<dir> [<file>|<dir>...]\n"
+          "Defragment file data or directory metadata.\n"
+                "-v         be verbose\n"
+                "-c         compress the file while defragmenting\n"
+                "-f         flush data to disk immediately after defragmenting\n"
+                "-s start   defragment only from byte onward\n"
+                "-l len     defragment only up to len bytes\n"
+                "-t size    minimal size of file to be considered for defragmenting\n"
 	},
 	{ do_set_default_subvol, 2,
 	  "subvolume set-default", "<id> <path>\n"
 		"Set the subvolume of the filesystem <path> which will be mounted\n"
-		"as default."
+		"as default.",
+          NULL
 	},
 	{ do_fssync, 1,
 	  "filesystem sync", "<path>\n"
-		"Force a sync on the filesystem <path>."
+		"Force a sync on the filesystem <path>.",
+          NULL
 	},
 	{ do_resize, 2,
 	  "filesystem resize", "[+/-]<newsize>[gkm]|max <filesystem>\n"
 		"Resize the file system. If 'max' is passed, the filesystem\n"
-		"will occupe all available space on the device."
+		"will occupe all available space on the device.",
+          NULL
 	},
 	{ do_show_filesystem, 999,
 	  "filesystem show", "[<uuid>|<label>]\n"
 		"Show the info of a btrfs filesystem. If no <uuid> or <label>\n"
-		"is passed, info of all the btrfs filesystem are shown."
+		"is passed, info of all the btrfs filesystem are shown.",
+          NULL
 	},
 	{ do_df_filesystem, 1,
 	  "filesystem df", "<path>\n"
-		"Show space usage information for a mount point\n."
+		"Show space usage information for a mount point.",
+          NULL
 	},
 	{ do_balance, 1,
 	  "filesystem balance", "<path>\n"
-		"Balance the chunks across the device."
+		"Balance the chunks across the device.",
+          NULL
 	},
 	{ do_scan,
 	  999, "device scan", "[<device> [<device>..]\n"
 		"Scan all device for or the passed device for a btrfs\n"
-		"filesystem."
+		"filesystem.",
+          NULL
 	},
 	{ do_add_volume, -2,
 	  "device add", "<dev> [<dev>..] <path>\n"
-		"Add a device to a filesystem."
+		"Add a device to a filesystem.",
+          NULL
 	},
 	{ do_remove_volume, -2,
 	  "device delete", "<dev> [<dev>..] <path>\n"
-		"Remove a device from a filesystem."
+		"Remove a device from a filesystem.",
+          NULL
 	},
 	/* coming soon
 	{ 2, "filesystem label", "<label> <path>\n"
-		"Set the label of a filesystem"
+		"Set the label of a filesystem",
+          NULL
 	}
 	*/
-	{ 0, 0 , 0 }
+	{ 0, 0, 0, 0 }
 };
 
 static char *get_prgname(char *programname)
@@ -128,17 +156,25 @@ static char *get_prgname(char *programname)
 	return np;
 }
 
-static void print_help(char *programname, struct Command *cmd)
+static void print_help(char *programname, struct Command *cmd, int helptype)
 {
 	char	*pc;
 
 	printf("\t%s %s ", programname, cmd->verb );
 
-	for(pc = cmd->help; *pc; pc++){
-		putchar(*pc);
-		if(*pc == '\n')
-			printf("\t\t");
-	}
+        if (helptype == ADVANCED_HELP && cmd->adv_help)
+                for(pc = cmd->adv_help; *pc; pc++){
+                        putchar(*pc);
+                        if(*pc == '\n')
+                                printf("\t\t");
+                }
+        else
+	        for(pc = cmd->help; *pc; pc++){
+		        putchar(*pc);
+		        if(*pc == '\n')
+			        printf("\t\t");
+	        }
+
 	putchar('\n');
 }
 
@@ -148,10 +184,10 @@ static void help(char *np)
 
 	printf("Usage:\n");
 	for( cp = commands; cp->verb; cp++ )
-		print_help(np, cp);
+		print_help(np, cp, BASIC_HELP);
 
 	printf("\n\t%s help|--help|-h\n\t\tShow the help.\n",np);
-	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a command or\n\t\t"
+	printf("\n\t%s <cmd> --help\n\t\tShow detailed help for a command or"
             "subset of commands.\n",np);
 	printf("\n%s\n", BTRFS_BUILD_VERSION);
 }
@@ -257,15 +293,14 @@ static int prepare_args(int *ac, char ***av, char *prgname, struct Command *cmd
 
 
 /*
-
-	This function perform the following jobs:
+	This function performs the following jobs:
 	- show the help if '--help' or 'help' or '-h' are passed
 	- verify that a command is not ambiguous, otherwise show which
 	  part of the command is ambiguous
-	- if after a (even partial) command there is '--help' show the help
+	- if after a (even partial) command there is '--help' show detailed help
 	  for all the matching commands
-	- if the command doesn't' match show an error
-	- finally, if a command match, they return which command is matched and
+	- if the command doesn't match show an error
+	- finally, if a command matches, they return which command matched and
 	  the arguments
 
 	The function return 0 in case of help is requested; <0 in case
@@ -319,7 +354,7 @@ static int parse_args(int argc, char **argv,
 		if(argc>i+1 && !strcmp(argv[i+1],"--help")){
 			if(!helprequested)
 				printf("Usage:\n");
-			print_help(prgname, cp);
+			print_help(prgname, cp, ADVANCED_HELP);
 			helprequested=1;
 			continue;
 		}
-- 
1.7.3.5

