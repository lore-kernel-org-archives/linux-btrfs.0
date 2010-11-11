From: Josh Berry <des@condordes.net>
Subject: Re: Unhelpful error message from "btrfs" tool
Date: Thu, 11 Nov 2010 13:10:32 -0800
Message-ID: <AANLkTim5OEjrVCL+jfC6avWUgsWnQv9fVxHGLO0H=4fn@mail.gmail.com>
References: <AANLkTi=8e5fBDKhKDOP0ayXCZ5uZrTNVxikM8mwqobGs@mail.gmail.com>
	<AANLkTin1Ra8MMCxL1Nsbyog82ke7yemAFur_XQ_1NuXj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin1Ra8MMCxL1Nsbyog82ke7yemAFur_XQ_1NuXj@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 11, 2010 at 12:10, C Anthony Risinger <anthony@extof.me> wr=
ote:
> On Thu, Nov 11, 2010 at 2:04 PM, Josh Berry <des@condordes.net> wrote=
:
>> Hi,
>>
>> I have a cron script that runs periodically, taking new snapshots an=
d
>> cleaning up old ones when space gets low on my filesystem. =C2=A0Thi=
s
>> morning, the script suddenly stopped being able to remove snapshots.
>> When I tried to remove one manually, I got the following:
>>
>> # btrfs subvol del 2010-11-07-01:17:01
>> Delete subvolume '/btrfs/snapshot/2010-11-07-01:17:01'
>> ERROR: cannot delete '/btrfs/snapshot/2010-11-07-01:17:01'
>>
>> There is nothing in dmesg or in the above output to tell me what the
>> problem is, how to fix it, etc. =C2=A0I'm running kernel 2.6.36, and=
 I
>> updated btrfs-progs-unstable to the lastest Git revision
>> (1b444cd2e6...), with the same result.
>>
>> How do I diagnose this issue? =C2=A0I'm not even sure where to start=
=2E
>
> do you have other nested subvols in it by accident? =C2=A0try `btrfs =
sub
> list` to be sure.

That was the problem -- somehow there was another subvol inside.  Thank=
s!

-- Josh
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
