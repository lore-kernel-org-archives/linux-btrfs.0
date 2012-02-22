From: Olivier Bonvalet <btrfs.list@daevel.fr>
Subject: Re: btrfs-convert processing time
Date: Wed, 22 Feb 2012 17:55:54 +0100
Message-ID: <4F451E1A.4000802@daevel.fr>
References: <4F4241D1.4080506@daevel.fr> <20458953.qbO19NXijp@k85hala03> <4F424D8D.4030802@daevel.fr> <1920178.zXOEpupmQW@k85hala03> <CAG1y0sevgB0=Y-Sxe_N4zGeZvYp+Pmpjv0q8JeRg22qtkZ0tJw@mail.gmail.com> <4F4258D5.4070101@daevel.fr> <CAG1y0sdUeXwMXRfeuqOosRtpj_TpB_8cxw0xpGXw+LaRDSAD9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdUeXwMXRfeuqOosRtpj_TpB_8cxw0xpGXw+LaRDSAD9A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

So, the btrfs-convert for the smaller drive is done... after near 5 
days. Which stats can I give you ?

It's a 340GB LVM block device, and "btrfs filesystem df /backup/" say that :

Data: total=225.97GB, used=181.94GB
System: total=32.00MB, used=24.00KB
Metadata: total=111.00GB, used=91.56GB


If I mount the ext2_saved/image copy, I can see 257GB of data (78% of 
the block device used), with 17M of inodes.


The other btrfs-convert stay running.
