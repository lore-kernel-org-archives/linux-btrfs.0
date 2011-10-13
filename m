From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: is space really freed after deleting large subvolume?
Date: Thu, 13 Oct 2011 21:22:44 +0200
Message-ID: <CAJ1PRSn_o6yup4GuojrUQPvYgrZzTivqb+iojK6SyfdhCySKeg@mail.gmail.com>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
	<20111013162104.GG21931@carfax.org.uk>
	<CAJ1PRSmHecopafvi_oXDjeSFntZHWH2a714usf7ujrUA14SHCQ@mail.gmail.com>
	<CAJ1PRS=hJmj-sFRmAqtWcvwawNmCzWvfa3paH5dc_mfTgnUn7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: rm@romanrm.ru, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRS=hJmj-sFRmAqtWcvwawNmCzWvfa3paH5dc_mfTgnUn7g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>>Only umount does, and it can take a very long time if you >>have deleted a large
>>(differing a lot) subvolume just before that.

does it mean that I won't be able to cleanly reboot machine after
deleting subvolume with milions of files?

And most important question is if deleting btrfs subvolume with 5mln
requiress less io operations than deleting 5mln of files on normal
filesystem (like ext3) (by rm -rf)???
