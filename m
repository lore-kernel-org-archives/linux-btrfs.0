From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: Re: is space really freed after deleting large subvolume?
Date: Thu, 13 Oct 2011 20:06:50 +0200
Message-ID: <CAJ1PRS=hJmj-sFRmAqtWcvwawNmCzWvfa3paH5dc_mfTgnUn7g@mail.gmail.com>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com>
	<20111013162104.GG21931@carfax.org.uk>
	<CAJ1PRSmHecopafvi_oXDjeSFntZHWH2a714usf7ujrUA14SHCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRSmHecopafvi_oXDjeSFntZHWH2a714usf7ujrUA14SHCQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> And what affect this rate of space reclaiming? When does it happen?
> Also I guess that if it happens it must lower overall io performance
> and rise loadavg ...?
>

and finaly is the performance overhead same as deleting same number of
files in system like ext3? When you delete large number of files in
ext3 (or any other system) you are looking at huge io traffic during
deletion. You are saying that in btrfs if you delete subvolume (that
had many files) you don't get free space instantenously so when and is
prerformance overhead basicly overaly SAME but in time? higher? lower?
