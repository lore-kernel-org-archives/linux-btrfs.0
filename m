From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: how can I copy files bigger than ~32 GB when using compress-force?
Date: Mon, 04 Oct 2010 23:42:12 +0200
Message-ID: <4CAA4A34.80701@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> I'm assuming this works without compress-force?  I can make a guess at
> what is happening, the compression forces a relatively small extent
> size, and this is making our worst case metadata reservations get upset.

Yes, it works without compress-force.

Interesting is that cp or rsync sometimes just exit quite fast with "no 
space left".

Sometimes, they just "hang" (waited up to about an hour) - file size 
does not grow anymore, last modified time is not updated, iostat does 
not show any bytes read/written, there are no btrfs or any other 
processes taking too much CPU, cp/rsync is not in "D" state (although it 
gets to "D" state and uses 100% CPU as I try to kill it).

Could it be we're hitting two different bugs here?


> Does it happen with any 32gb file that doesn't compress well?

The 220 GB qcow2 file was basically uncompressible (backuppc archive 
full of bzip2-compressed files).


-- 
Tomasz Chmielewski
http://wpkg.org

