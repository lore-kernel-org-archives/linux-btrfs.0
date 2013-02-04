Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46477 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab3BDBNN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Feb 2013 20:13:13 -0500
Message-ID: <510F0AE4.4070608@cn.fujitsu.com>
Date: Mon, 04 Feb 2013 09:12:04 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Is it possible to use send & receive features to clone the btrfs
 partition efficiently (including all snapshots inside)?
References: <510E6714.7040206@statystyka.net>
In-Reply-To: <510E6714.7040206@statystyka.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> It is very difficult for me to find any good documentation on send & receive commands. Event the most recent btrfs progs man page (accessed from git today) says nothing.
> 
> I want to migrate data (including numerous read only snaphots) from linux-raid - based storage into a native raid btrfs.
> 
> I think that cloning via send & receive is a viable option.
> 
> Can anyone help me please? I've posted my question also on stackexchange: http://unix.stackexchange.com/questions/63528/how-to-clone-btrfs-filesystem-into-different-medium-preserving-snapshots-sharin . I will post the answer there, so everyone can benefit from it.
> 
> Thank you,
> 
> Adam Ryczkowski
> +48505919892 <callto:+48505919892>
> Skype:sisteczko <skype:sisteczko>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

usage: btrfs send [-v] [-i <subvol>] [-p <parent>] [-f <outfile>] <subvol>

    Send the subvolume to stdout.

    Sends the subvolume specified by <subvol> to stdout.
    By default, this will send the whole subvolume. To do
    an incremental send, one or multiple '-i <clone_source>'
    arguments have to be specified. A 'clone source' is
    a subvolume that is known to exist on the receiving
    side in exactly the same state as on the sending side.

    Normally, a good snapshot parent is searched automatically
    in the list of 'clone sources'. To override this, use
    '-p <parent>' to manually specify a snapshot parent.
    A manually specified snapshot parent is also regarded
    as 'clone source'.

    -v               Enable verbose debug output. Each
                     occurrence of this option increases the
                     verbose level more.
    -i <subvol>      Informs btrfs send that this subvolume,
                     can be taken as 'clone source'. This can
                     be used for incremental sends.
    -p <subvol>      Disable automatic snapshot parent
                     determination and use <subvol> as parent.
                     This subvolume is also added to the list
                     of 'clone sources' (see -i).
    -f <outfile>     Output is normally written to stdout.
                     To write to a file, use this option.
                     An alternative would be to use pipes.


usage: btrfs receive [-v] [-f <infile>] <mount>

    Receive subvolumes from stdin.

    Receives one or more subvolumes that were previously 
    sent with btrfs send. The received subvolumes are stored
    into <mount>.
    btrfs receive will fail in case a receiving subvolume
    already exists. It will also fail in case a previously
    received subvolume was changed after it was received.
    After receiving a subvolume, it is immediately set to
    read only.

    -v               Enable verbose debug output. Each
                     occurrence of this option increases the
                     verbose level more.
    -f <infile>      By default, btrfs receive uses stdin
                     to receive the subvolumes. Use this
                     option to specify a file to use instead.
