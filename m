From: David Pottage <david@electric-spoon.com>
Subject: Re: is space really freed after deleting large subvolume?
Date: Thu, 13 Oct 2011 21:01:44 +0100
Message-ID: <4E9743A8.1050806@electric-spoon.com>
References: <CAJ1PRSmDmd4mrUaQAhjCt1SMtVaBVxq3dCVjCuT20Y4Wf+Ch+Q@mail.gmail.com> <20111013162104.GG21931@carfax.org.uk> <CAJ1PRSmHecopafvi_oXDjeSFntZHWH2a714usf7ujrUA14SHCQ@mail.gmail.com> <CAJ1PRS=hJmj-sFRmAqtWcvwawNmCzWvfa3paH5dc_mfTgnUn7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com" <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRS=hJmj-sFRmAqtWcvwawNmCzWvfa3paH5dc_mfTgnUn7g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 13/10/11 19:06, krzf83@gmail.com wrote:
>> And what affect this rate of space reclaiming? When does it happen?
>> Also I guess that if it happens it must lower overall io performance
>> and rise loadavg ...?
>>
> and finaly is the performance overhead same as deleting same number of
> files in system like ext3? When you delete large number of files in
> ext3 (or any other system) you are looking at huge io traffic during
> deletion. You are saying that in btrfs if you delete subvolume (that
> had many files) you don't get free space instantenously so when and is
> prerformance overhead basicly overaly SAME but in time? higher? lower?
ext3 is slow to delete lots of files because the filesystem is block
based, so if you delete a large file (eg an ISO image), then ext3 has to
make a huge number of updates to the free space map to say that those
blocks are now free.

btrfs like ext4 has support for extents, which can be any size, so
typically if you delete a large file, then it occupies only one extent,
so only that one extent needs to be marked as free, so a lot less I/O.

If you delete a large number of files, then there is no avoiding the
fact that a lot of metadata needs to be updated. In this respect btrfs
is unlikely to be significantly faster than any other filing system.

-- 
David Pottage

