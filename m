From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: No space left on device, btrfsctl segmentation fault
Date: Thu, 25 Feb 2010 08:56:46 +0100
Message-ID: <23a15591002242356r7b6f0394wd0ab45fa53668f67@mail.gmail.com>
References: <2b0225fb1002231939q2020bf05g145f852e5b4c560@mail.gmail.com>
	 <20100224154353.GB2257@localhost.localdomain>
	 <2b0225fb1002241120y34f9f934na9d43a4fcfda2ac3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Boyd Waters <waters.boyd@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2b0225fb1002241120y34f9f934na9d43a4fcfda2ac3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

The patch is here: http://patchwork.kernel.org/patch/81547/ , it's for =
kernel.

But I have just seen weird behaviour with my btrfs, I'm not sure
whether it's my patch or the new changes I have pulled from git - I'd
recommend you wait with trying out this patch until someone diagnoses
what failed with my fs :-)

And as for metadata size - "btrfs-vol -b" reduces the metadata amount
by a large amount for filesystems containing huge files.

On Wed, Feb 24, 2010 at 8:20 PM, Boyd Waters <waters.boyd@gmail.com> wr=
ote:
> Thanks for the suggestions, everyone!
>
> I copied the data from the 2TB btrfs disk to an identical disk (same
> make and model) formatted with ext4:
>
> /dev/sdi2 =A0 =A0 =A0 =A0 =A0 =A0 1.9T =A01.7T =A0197G =A090% /media/=
onlyhope
> /dev/sdg1 =A0 =A0 =A0 =A0 =A0 =A0 1.8T =A01.7T =A0 71G =A096% /mnt/ne=
whope
>
> The metadata "overhead" for btrfs is a bit more, but it isn't outrage=
ous IMHO.
>
> =3D=3D
>
> Re-balancing the tree with "btrfs-vol -b" sounds about right, both in
> terms of time and stability. I haven't tried that yet, but I can
> report on that experiment.
>
> Leszek wrote:
>> The 'used' output of df on a btrfs system does not take metadata int=
o
> account. So the disk is really full. This is what my yesterdays path
> is intended to fix - can you try it out?
>>
>
> I would like to try this patch, I apologize for being so new to btrfs
> development: can you tell me where to find the patch? Is it for btrfs
> tools or the btrfs itself? I will try to find it, but a quick pointer
> to it will help me test!
>
> Thanks again!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
