Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39893 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2LQD7b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Dec 2012 22:59:31 -0500
Date: Mon, 17 Dec 2012 11:57:40 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Sylvain Alain <d2racing911@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume snapshot performance problem
Message-ID: <20121217035739.GB2481@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CACR_K2uer3bniWAenoKe=-2BxT4vt4opXywCBbwGuaX7C8EgLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACR_K2uer3bniWAenoKe=-2BxT4vt4opXywCBbwGuaX7C8EgLA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 16, 2012 at 06:28:01PM -0500, Sylvain Alain wrote:
> Hi everyone, I'm still have the problem with the snapshot command.
> 
> Here what I tested today :
> 
> read  writ|files  inodes
>    0   408k| 2784   7264
>    0   460k| 2784   7264
>    0   496k| 2784   7264
>    0   424k| 2784   7264
>    0   440k| 2784   7264
>    0  1280k| 2784   7264
>    0   500k| 2784   7264
>    0   592k| 2784   7264
>    0   600k| 2784   7264
>    0   568k| 2784   7264
>    0   792k| 2784   7264
>    0   756k| 2784   7264
>    0   480k| 2784   7264
>    0   592k| 2784   7264
>    0   432k| 2784   7264
>    0   544k| 2784   7264
>    0   512k| 2784   7264
>    0  2912k| 2784   7264
>    0  3332k| 2784   7264
>    0    40M| 2784   7264
>    0    52M| 2784   7264
>    0  1280k| 2784   7264
>    0    69M| 2784   7264
> -dsk/total- --filesystem-
>  read  writ|files  inodes
>    0  5584k| 2784   7264
>    0   784k| 2784   7264
>    0   624k| 2784   7264
>    0   616k| 2784   7264
>    0   744k| 2784   7264
>    0   736k| 2784   7264
>    0   652k| 2784   7264
>    0   540k| 2784   7264
>    0   752k| 2784   7264
>    0   780k| 2784   7264
>    0   888k| 2784   7264
>    0   480k| 2784   7264
>    0   504k| 2784   7264
>    0   548k| 2784   7264
>    0   892k| 2784   7264
>    0   580k| 2784   7264
>    0   576k| 2784   7264
>    0   636k| 2784   7264
>    0   544k| 2784   7264
>    0   760k| 2784   7264
>    0   752k| 2784   7264
>    0   648k| 2784   7264
>    0   744k| 2784   7264
> -dsk/total- --filesystem-
>  read  writ|files  inodes
>    0   516k| 2784   7264
>    0   608k| 2784   7264
>    0   672k| 2784   7264
>    0   524k| 2784   7264
>    0   524k| 2784   7264
>    0   520k| 2784   7264
>    0   476k| 2784   7264
>    0   520k| 2784   7264
>    0   568k| 2784   7264
>    0   520k| 2784   7264
>    0   548k| 2784   7264
>    0   616k| 2784   7264
>    0   832k| 2784   7264
>    0   824k| 2784   7264
>    0   700k| 2784   7264
>    0   864k| 2784   7264
>    0  1208k| 2784   7264
>    0  1064k| 2784   7264
>    0   588k| 2784   7264
>    0   688k| 2784   7264
>    0    41M| 2784   7264
>  308k   17M| 2784   7269
> 7488k  456k| 2784   7268
> -dsk/total- --filesystem-
>  read  writ|files  inodes
> 8192B  496k| 2784   7268 ^C
> 
> When the snapshot run, you see that the write change from K to M.
> 
> And now I have a good example for my problem :
> 
> gentootux ~ # mount /dev/sda4 -o
> noatime,ssd,discard,compress=lzo,noacl,space_cache,subvolid=0
> /mnt/disklayout/
> gentootux ~ # cd /mnt/disklayout/
> gentootux disklayout # ls
> @backup  @racine
> gentootux disklayout # time btrfs subvolume delete @backup
> Delete subvolume '/mnt/disklayout/@backup'
> 
> real   0m0.005s
> user   0m0.001s
> sys   0m0.002s
> gentootux disklayout # ls
> @racine
> gentootux disklayout # time btrfs subvolume snapshot @racine @backup
> Create a snapshot of '@racine' in './@backup'
> 
> real   0m2.850s
> user   0m0.000s
> sys   0m0.010s
> gentootux disklayout # ls
> @backup  @racine
> gentootux disklayout # time btrfs subvolume delete @backup
> Delete subvolume '/mnt/disklayout/@backup'
> 
> real   0m0.001s
> user   0m0.000s
> sys   0m0.000s

Could you please add a 'sync' between them and post the output here?

Something like:

# btrfs subvolume delete @backup &&
# sync &&
# time btrfs subvolume snapshot @racine @backup

thanks,
liubo

> gentootux disklayout # time btrfs subvolume snapshot @racine @backup
> Create a snapshot of '@racine' in './@backup'
> 
> real   3m53.616s
> user   0m0.000s
> sys   0m0.299s
> 
> Instead of 3 secondes to run the snapshot, it took almost 4 minutes.
> 
> Is there any btrfs log that I could look at to detect the bottleneck ?
> 
> For the record, when this happens inside my Xfce desktop, if I try to
> launch a terminal, nothing happen, it's like my PC freeze until the
> snapshot is done.
> 
> Thanks !
> 
> --
> Salut
> alp
> Sylvain
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
