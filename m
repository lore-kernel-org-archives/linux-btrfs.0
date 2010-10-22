From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Subject: Mark btrfsctl deprecated
Date: Fri, 22 Oct 2010 14:02:49 +0200 (CEST)
Message-ID: <22986774.2784821287748969875.JavaMail.defaultUser@defaultHost>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

what do you think about marking deprecate the "btrfsctl" program ?

A lot of people make patch involving both btrfs command and btrfsctl command, 
spending a lot of effort. 

Initially we can put a warning in the btrfctl command which suggest to use the 
btrfs command. and after XX month (six ?) we could remouve the command at all. 
The same for the other utilities like btrfs-show, btrfs-vol....

Of course this is applicable if there is no evidence of regression of btrfs vs 
btrfsctl.

Regards
G.Baroncelli


