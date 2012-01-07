From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH] Btrfs-progs: restriper interface
Date: Sat, 7 Jan 2012 18:21:14 +0100
Message-ID: <201201071821.15315.kreijack@inwind.it>
References: <1325860680-19403-1-git-send-email-idryomov@gmail.com> <20120107151443.GA9084@zambezi.lan> <201201071749.01583.kreijack@inwind.it>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201201071749.01583.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, 07 January, 2012 17:49:01 Goffredo Baroncelli wrote:
> On Saturday, 07 January, 2012 16:14:43 you wrote:
[..]
> > btrfs instead tries to be clever, and if ip was doing the same thing
> > btrfs does you would get "ambiguous command 'r'" error in response to
> > "ip r".
> 
> You are right, but this is a bug.
> 
> 1) btrfs s sn -> means  btrfs subvolume snapshot
> 2) btrfs s se -> means  btrfs subvolume set-default
> 3) btrfs s s -> is ambiguous command because it could means both 1) and 2)
> 
> However if we try 1) we get an error. But this is not the intended
> behavior. I have to investigate why.

The change should be quite simple

diff --git a/btrfs.c b/btrfs.c
index 1def354..981afa4 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -268,8 +268,8 @@ static int check_ambiguity(struct Command *cmd, char 
**argv)
                        if( cp->ncmds < i )
                                continue;
 
-                       for( skip = 0, j = 0 ; j < i ; j++ )
-                               if( strcmp(cmd->cmds[j], cp->cmds[j])){
+                       for( skip = 0, j = 0 ; j <= i ; j++ )
+                               if( !strcmp(cmd->cmds[j], cp->cmds[j])){
                                        skip=1;
                                        break;
                                }


But before issue a new patch I want to be sure about its correctness. I have 
to make a more formal test. 

> 
> BR
> G.Baroncelli
> 
> > Thanks,
> > 
> > 		Ilya

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
