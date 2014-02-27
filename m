Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56268 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaB0NKb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 08:10:31 -0500
Received: by mail-ee0-f48.google.com with SMTP id e51so300709eek.7
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 05:10:29 -0800 (PST)
Received: from linuxpc.localnet (194-118-185-100.adsl.highway.telekom.at. [194.118.185.100])
        by mx.google.com with ESMTPSA id o43sm16731445eef.12.2014.02.27.05.10.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 27 Feb 2014 05:10:29 -0800 (PST)
From: GEO <1g2e3o4@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup over writable snapshot
Date: Thu, 27 Feb 2014 14:10:25 +0100
Message-ID: <1682169.l7oZKuLmJy@linuxpc>
In-Reply-To: <17860756.QfG9CfNMqv@linuxpc>
References: <17860756.QfG9CfNMqv@linuxpc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does anyone have a technical info regarding the reliability of the incremental 
backup process using the said method?
(Apart from all the recommendations not to do it that way)
So the question I am interested in: Should it work or not?
I did some testing myself and it seemed to work, however I cannot find out if 
it backs up unnecessary blocks and thus making the incremental step space 
inefficient.
That information would help me very much!
Thank you very much!

On Wednesday 19 February 2014 14:45:57 GEO wrote:
> Hi,
> 
> As suggested in another thread, I would like to know the reliability of the
> following backup scheme:
> 
> Suppose I have a subvolume of my homedirectory  called @home.
> 
> Now I am interested in making incremental backups of data in home I am
> interested in, but not everything, so I create a normal snapshot of @home
> called @home-w and delete the files/folders I am not interested in backing
> up. After that I create a readonly snapshot of @home-w called @home-r, that
> I sent to my target volume with btrfs send.
> 
> After that is done, I do regular backups, by always going over the writeable
> snapshot where I remove always the same directories I am not interested and
> send the difference to the target volume with  btrfs send -p @home-r
> @home-r-1| btrfs receive /path/of/target/volume.
> 
> I do not like the idea of making subvolumes of all directories I am not
> interested in backing up.
> 
> So what I would like to know now is the following: Could there be drawbacks
> of doing this resp. could I further optimize my backup strategy, as I
> experienced it takes a while for deleting large files in the writeable
> snapshot (What does it write there?)
> 
> Could my method somehow lead to inefficiency in terms of the disk space used
> at the target volume (I mean, could the deleting cause a change, so that
> more is actually transferred as change, than in reality is?)?
> 
> One last question would be: Is there a quick way I could verify the local
> read only snapshot used last time is the same as the one synced to the
> target volume last time?
> 
> 
> Thank you for your support and the great work!


