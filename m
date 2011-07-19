From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH 5/6] Show the help messages from the info in the comment.
Date: Tue, 19 Jul 2011 18:12:22 +0200
Message-ID: <20110719161222.3210.30489.stgit@venice.bhome>
References: <20110719161049.3210.54794.stgit@venice.bhome>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110719161049.3210.54794.stgit@venice.bhome>
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

The makefile is update in order to use the tool "helpextract" to extract
the info from the sources comments and to generate the file "helpmsg.c"
which contains an array of string with all the information.
Then the function "print_help" prints these information.
---
 btrfs.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 98abb6c..53422f7 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -357,6 +357,8 @@ static struct Command commands[] = {
 	{ 0, 0, 0, 0 }
 };
 
+extern char * help_messages[];
+
 static char *get_prgname(char *programname)
 {
 	char	*np;
@@ -372,21 +374,43 @@ static char *get_prgname(char *programname)
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

