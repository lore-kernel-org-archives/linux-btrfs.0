Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:18229 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab2GKHRD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jul 2012 03:17:03 -0400
Message-ID: <4FFD278D.20804@oracle.com>
Date: Wed, 11 Jul 2012 15:13:17 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: "haveaniceday@cv-sv.de" <haveaniceday@cv-sv.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfsck crashes
References: <4FF9B07C.8090209@cv-sv.de> <4FFA52BC.9010401@oracle.com> <4FFB4BB4.4080408@cv-sv.de> <4FFBCC1A.8020800@oracle.com> <1462124570.240756.1341911618590.JavaMail.open-xchange@email.1und1.de> <333721177.250041.1341918535801.JavaMail.open-xchange@email.1und1.de>
In-Reply-To: <333721177.250041.1341918535801.JavaMail.open-xchange@email.1und1.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  If this is a deliberate corruption can you pls share the test-case ?
  if not have you tried mount with recovery and the scrub. ? scrub
  would be preferred choice over btrfsck.



On 10/07/12 19:08, haveaniceday@cv-sv.de wrote:
> This code should detect the problem without SIGSEGV but a Assertition.
> ...
> Csum didn't match
> btrfsck: btrfsck.c:1177: walk_down_tree: Assertion `!(1)' failed.
> Aborted
> ...
>
>
> --- btrfsck.c   2012-07-10 10:23:24.781622144 +0200
> +++ btrfsck.c   2012-07-10 12:59:00.120146266 +0200
> @@ -1173,7 +1173,7 @@
>                  WARN_ON(*level>= BTRFS_MAX_LEVEL);
>                  cur = path->nodes[*level];
>
> -               if (btrfs_header_level(cur) != *level)
> +               if (! cur || btrfs_header_level(cur) != *level)
>                          WARN_ON(1);
>
>                  if (path->slots[*level]>= btrfs_header_nritems(cur))
>
>   I tried to skip this error with the code below. The next errors reported are
> also below.
>
>
> --- btrfsck.c   2012-07-10 10:23:24.781622144 +0200
> +++ btrfsck.c   2012-07-10 12:36:51.995996771 +0200
> @@ -1173,8 +1173,13 @@
>                  WARN_ON(*level>= BTRFS_MAX_LEVEL);
>                  cur = path->nodes[*level];
>
> -               if (btrfs_header_level(cur) != *level)
> -                       WARN_ON(1);
> +               if (cur != 0 ) {
> +                       if ( btrfs_header_level(cur) != *level)
> +                               WARN_ON(1);
> +               }else {
> +                       fprintf(stderr, "CVCV path->nodes[*level] is 0!\n");
> +                       break;
> +               }
>
>                  if (path->slots[*level]>= btrfs_header_nritems(cur))
>                          break;
> @@ -1213,7 +1218,11 @@
>                  path->slots[*level] = 0;
>          }
>   out:
> +       if ( path->nodes[*level] != 0 ){
>          path->slots[*level] = btrfs_header_nritems(path->nodes[*level]);
> +       } else {
> +       path->slots[*level] = 0;
> +       }
>          return 0;
>   }
>
> Next errors I get are:
>
> ....
> checking fs roots
> checksum verify failed on 2327654400 wanted 73CDE79C found 72
> checksum verify failed on 2327654400 wanted 73CDE79C found 72
> checksum verify failed on 2327654400 wanted 73CDE79C found 72
> checksum verify failed on 2327654400 wanted 73CDE79C found 72
> Csum didn't match
> CVCV path->nodes[*level] is 0!
> root 5 inode 265 errors 2000
>          unresolved ref dir 2658782 index 3 namelen 12 name aquota.group filetype
> 0 error 3
>          unresolved ref dir 2914579 index 3 namelen 12 name aquota.group filetype
> 0 error 3
> root 5 inode 266 errors 2000
>          unresolved ref dir 2658782 index 4 namelen 11 name aquota.user filetype
> 0 error 3
>          unresolved ref dir 2914579 index 4 namelen 11 name aquota.user filetype
> 0 error 3
> root 5 inode 285 errors 2000
>          unresolved ref dir 2658783 index 3 namelen 3 name awk filetype 0 error 3
>          unresolved ref dir 2914580 index 3 namelen 3 name awk filetype 0 error 3
> root 5 inode 286 errors 2000
>          unresolved ref dir 2658783 index 16 namelen 3 name csh filetype 0 error
> 3
>          unresolved ref dir 2914580 index 16 namelen 3 name csh filetype 0 error
> 3
> root 5 inode 287 errors 2000
>          unresolved ref dir 2658783 index 27 namelen 13 name dnsdomainname
> filetype 0 error 3
>          unresolved ref dir 2914580 index 27 namelen 13 name dnsdomainname
> filetype 0 error 3
> root 5 inode 288 errors 2000
>          unresolved ref dir 2658783 index 28 namelen 10 name domainname filetype
> 0 error 3
>          unresolved ref dir 2914580 index 28 namelen 10 name domainname filetype
> 0 error 3
> root 5 inode 289 errors 2000
>          unresolved ref dir 2658783 index 34 namelen 2 name ex filetype 0 error 3
>          unresolved ref dir 2914580 index 34 namelen 2 name ex filetype 0 error 3
> root 5 inode 290 errors 2000
>          unresolved ref dir 2658783 index 48 namelen 2 name ip filetype 0 error 3
>          unresolved ref dir 2914580 index 48 namelen 2 name ip filetype 0 error 3
> root 5 inode 291 errors 2000
>          unresolved ref dir 2658783 index 54 namelen 3 name ksh filetype 0 error
> 3
>          unresolved ref dir 2914580 index 54 namelen 3 name ksh filetype 0 error
> 3
> root 5 inode 292 errors 2000
>          unresolved ref dir 2658783 index 63 namelen 4 name mail filetype 0 error
> 3
>          unresolved ref dir 2914580 index 63 namelen 4 name mail filetype 0 error
> 3
> ...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
