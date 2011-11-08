From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/7][V2] btrfs-progs:  Show the help messages from the info in the comment.
Date: Tue, 08 Nov 2011 23:12:02 +0100
Message-ID: <12465892.zMVxNaAe1e@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart4575814.BGFcrGf32K"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo-lkml@carfax.org.uk>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart4575814.BGFcrGf32K
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi all,

the following set of patches implement a way to generate the help messages and  
the btrfs man page from the sources comments for the "btrfs" command.

The syntax and the detailed help of every subcommand should be stored in
the comments before the function which implements the subcommand. See patch #4 
for an explanation on how document a command.

The fact that the help messages and the man page are generated from the 
same source should help to avoid in-coherencies and mistakes.
Moreover the fact that the source and the help are strictly linked
helps to avoid man page/help outdated.

These set of patches area base on the latest Chris's btrfs-progs repository.

Comparing my last set of patch (see my emails dated 2/November) , I had 
removed some text because the Chris's repository don't have all the commands 
present in the Hugo repository.

You can pull the changes from 

You can download the source from
        http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git

        branch man-page-from-source

and/or browse the code at
        http://cassiopea.homelinux.net/git/?p=btrfs-progs-unstable.git

Comments are welcome.

BR
G.Baroncelli



-----
The function "print_help" prints the help message extracted from the source.

Signed off by: Goffredo Baroncelli <kreijack@inwind.it>

---
 btrfs.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 1def354..cc2f7ca 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -182,6 +182,8 @@ static struct Command commands[] = {
 	{ 0, 0, 0, 0 }
 };
 
+extern char * help_messages[];
+
 static char *get_prgname(char *programname)
 {
 	char	*np;
@@ -197,21 +199,43 @@ static char *get_prgname(char *programname)
 static void print_help(char *programname, struct Command *cmd, int helptype)
 {
 	char	*pc;
+	int	i;
+	char	*adv_help;
+	char	*std_help;
+
+	/* printf("\t%s %s ", programname, cmd->verb ); */
+
+	adv_help = cmd->adv_help;
+	std_help = cmd->help;
+
+	for(i = 0; help_messages[i]; i+= 4 ){
+		if(!strncmp(help_messages[i],"btrfs ",6) &&
+		   !strcmp(help_messages[i]+6,cmd->verb) ){
+			if(help_messages[i+2])
+				std_help = help_messages[i+2];
+			if(help_messages[i+3])
+				adv_help = help_messages[i+3];
+			printf("\t%s\t\t",help_messages[i+1]);
+			break;
+		}
+	}
 
-	printf("\t%s %s ", programname, cmd->verb );
+	if( !help_messages[i])
+		printf("\t%s %s ", programname, cmd->verb );
 
-	if (helptype == ADVANCED_HELP && cmd->adv_help)
-		for(pc = cmd->adv_help; *pc; pc++){
+	if (helptype == ADVANCED_HELP && adv_help){
+		for(pc = adv_help; *pc; pc++){
 			putchar(*pc);
 			if(*pc == '\n')
 				printf("\t\t");
 		}
-	else
-		for(pc = cmd->help; *pc; pc++){
+	}else{
+		for(pc = std_help; *pc; pc++){
 			putchar(*pc);
 			if(*pc == '\n')
 				printf("\t\t");
 		}
+	}
 
 	putchar('\n');
 }
-- 
1.7.7.2

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart4575814.BGFcrGf32K
Content-Disposition: inline; filename="send-via-kmail-attach-28575-1320789394-5060.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-28575-1320789394-5060.msg"

diff --git a/btrfs.c b/btrfs.c
index 1def354..cc2f7ca 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -182,6 +182,8 @@ static struct Command commands[] = {
 	{ 0, 0, 0, 0 }
 };
 
+extern char * help_messages[];
+
 static char *get_prgname(char *programname)
 {
 	char	*np;
@@ -197,21 +199,43 @@ static char *get_prgname(char *programname)
 static void print_help(char *programname, struct Command *cmd, int helptype)
 {
 	char	*pc;
+	int	i;
+	char	*adv_help;
+	char	*std_help;
+
+	/* printf("\t%s %s ", programname, cmd->verb ); */
+
+	adv_help = cmd->adv_help;
+	std_help = cmd->help;
+
+	for(i = 0; help_messages[i]; i+= 4 ){
+		if(!strncmp(help_messages[i],"btrfs ",6) &&
+		   !strcmp(help_messages[i]+6,cmd->verb) ){
+			if(help_messages[i+2])
+				std_help = help_messages[i+2];
+			if(help_messages[i+3])
+				adv_help = help_messages[i+3];
+			printf("\t%s\t\t",help_messages[i+1]);
+			break;
+		}
+	}
 
-	printf("\t%s %s ", programname, cmd->verb );
+	if( !help_messages[i])
+		printf("\t%s %s ", programname, cmd->verb );
 
-	if (helptype == ADVANCED_HELP && cmd->adv_help)
-		for(pc = cmd->adv_help; *pc; pc++){
+	if (helptype == ADVANCED_HELP && adv_help){
+		for(pc = adv_help; *pc; pc++){
 			putchar(*pc);
 			if(*pc == '\n')
 				printf("\t\t");
 		}
-	else
-		for(pc = cmd->help; *pc; pc++){
+	}else{
+		for(pc = std_help; *pc; pc++){
 			putchar(*pc);
 			if(*pc == '\n')
 				printf("\t\t");
 		}
+	}
 
 	putchar('\n');
 }
-- 
1.7.7.2

--nextPart4575814.BGFcrGf32K--

