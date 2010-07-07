From: Yee-Ting Li <yee379@gmail.com>
Subject: Re: volume broken? btrfsck fails
Date: Tue, 6 Jul 2010 22:23:23 -0700
Message-ID: <60683458-F978-4555-94BF-43C3A1D2E6FE@gmail.com>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com> <20100707001622.GH15984@think>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100707001622.GH15984@think>
List-ID: <linux-btrfs.vger.kernel.org>


On 6 Jul 2010, at 17:16, Chris Mason wrote:
> These are definitely corruptions, and they probably came from the crash.
> Can you tell me more about the crash? (Power failure, what is the
> storage underneath etc, what are the write cache settings).  We don't
> expect these kinds corruptions to happen.

i think what happened was that the power got pulled accidentally. at the time i had a drive (sde) on an external usb controller. the other two drives are internal on a nForce 730i chipset. they are all 2TB WD drives (combination of EADS and EARS drives). according to hdparm all the drives have write-caching on.

> Yan Zheng is making a lot of progress on btrfsck, but I don't think
> you'll want to be one of the first testers there.  I can definitely help
> copy things off if you're having trouble accessing the FS.

i'm performing rsyncs at the moment to get some of the data off. i can read the drive fine, but after a while (i guess when something tries to access the corrupt file) i get the dmesgs again, and high cpu on the two btrfs-transacti and btrfs-endio-met threads.

is there a way i can determine the actual filenames that may be corrupt?

also, as i'm not using the /dev/sde drive (btrfs-show gives used 0.00TB) as i didn't do a balance after i installed it - is there a way i can degrade the array to recover that disk and keep the array with just two disks? then i will have enough storage to copy the 'good' files off :)

once i have a replica, then i can test whatever code you'd like to throw at me :)

cheers,

Yee.