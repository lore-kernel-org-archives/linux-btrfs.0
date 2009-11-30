From: jim owens <jowens@hp.com>
Subject: Re: Unable to mount loopback devices in RAID mode
Date: Mon, 30 Nov 2009 08:09:28 -0500
Message-ID: <4B13C408.10606@hp.com>
References: <200911192026.04694.lists-receive@programmierforen.de> <4B05D64B.7070705@hp.com> <200911202022.19306.lists-receive@programmierforen.de> <20091127053336.GD25509@jsoft.dyndns.org> <4B0FF6F9.9010603@hp.com> <20091130042851.GG25509@jsoft.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
To: Andi Drebes <lists-receive@programmierforen.de>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091130042851.GG25509@jsoft.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jean-S=E9bastien Trottier wrote:
> On Fri, Nov 27, 2009 at 10:57:45AM -0500, jim owens wrote:
>> Jean-S=E9bastien Trottier wrote:
>>> In the case of RAID1 (or even RAID10), what happens if loop0 is the
>>> current master but is corrupted/dead and you want to mount loop1 to
>>> recover your data?
>> The problem does not occur with raid1.  In that case, both copies
>> are updated and either can mount.  For raid10, 2 of the 4 devices
>> should always be mountable (you still have to find which 2).
>=20
> Hmmm... But Andi's original post shows he was having this problem wit=
h
> RAID1, no?

Ah, yes, I missed the raid1 part on the original post.

So I do not understand why it does not work correctly for
him to mount either device.  Maybe this problem is not
what I see in my testing (using 32) with disk partitions
instead of loop.

With partitions, I only see the mount problem on raid0,
not on raid1.

jim
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
