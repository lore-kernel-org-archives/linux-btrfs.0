From: Fabian Zeindl <fabian.zeindl@gmail.com>
Subject: Re: Why does Btrfs allow raid1 with mismatched drives? Also: How to look behind the curtain
Date: Thu, 5 Jan 2012 13:26:54 +0100
Message-ID: <82FEA956-FFE4-4A00-B895-AA381A35FEE7@gmail.com>
References: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com> <20120105094444.GF27122@carfax.org.uk> <DFD486DD-C324-43EE-82BC-87DDCF432DB6@gmail.com> (sfid-20120105_110507_083017_9F92DD8C) <201201051139.20334.Martin@lichtvoll.de>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201201051139.20334.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2012, at 11:39 , Martin Steigerwald wrote:
> "Allocating as many chunks as can fit across the drives" is also pret=
ty=20
> clear to me. So if BTRFS can=B4t allocate a new chunk on two devices,=
 its=20
> full. To me it seems obvious that BTRFS will not break the RAID-1=20
> redundancy guarentee unless a drive fails.

So (assuming 1GB chunksize):

if i create a raid-1, btrfs with a 3GB and a 7GB device, it will show m=
e ~10GB free space,
after saving a 1GB file, i will have 8GB left (-1GB on each device)
after saving another 1GB, i will have 6GB left (--- " ----)
after saving another 1GB, it's "suddenly" full?

=46abian--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
