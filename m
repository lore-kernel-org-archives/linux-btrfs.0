From: Josef Bacik <josef@redhat.com>
Subject: Re: =?UTF-8?B?4oCcYmlvIHRvbyBiaWfigJ0gcmVncmVzc2lvbiBhbmQgc2lsZW4=?=
 =?UTF-8?B?dCBkYXRhIGNvcnJ1cHRpb24gaW4gMy4w?=
Date: Tue, 09 Aug 2011 15:05:56 -0400
Message-ID: <4E418514.7050409@redhat.com>
References: <orwreobtuf.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orwreobtuf.fsf@livre.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/07/2011 09:00 PM, Alexandre Oliva wrote:
> tl;dr version: 3.0 produces =E2=80=9Cbio too big=E2=80=9D dmesg entri=
es and silently
> corrupts data in =E2=80=9Cmeta-raid1/data-single=E2=80=9D configurati=
ons on disks with
> different max_hw_sectors, where 2.6.38 worked fine.
>=20

I've reproduced this but I'm stuck on something else atm but I should
get to it soon.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
