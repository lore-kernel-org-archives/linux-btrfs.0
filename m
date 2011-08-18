From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: snapshot ctime // Re: [RFC] btrfs auto snapshot
Date: Thu, 18 Aug 2011 18:14:20 +0800
Message-ID: <4E4CE5FC.70600@oracle.com>
References: <4E4B2452.9070407@oracle.com> <20110817140433.GA32261@hendrix.borisch.local> <20110817211316.0414bb5a@natsu> <CALJXSJpVWHZEKp9uZ8SB-mdkr2U8kdU=-k1=2U3QsoWXsTHC2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Roman Mamedov <rm@romanrm.ru>, Dave <dave@thekilempire.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALJXSJpVWHZEKp9uZ8SB-mdkr2U8kdU=-k1=2U3QsoWXsTHC2Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>



On 08/17/2011 11:56 PM, J=C3=A9r=C3=B4me Poulin wrote:
> On Wed, Aug 17, 2011 at 11:13 AM, Roman Mamedov<rm@romanrm.ru>  wrote=
:
>> So until someone cares about snapshot ctime enough to fix this, btrf=
s will not be a convenient FS to work with timed snapshotting/cleanup.
>
> Isn't the ctime the creation date of the original folder?

  It will be a nice thing to have the snapshot time returned by
  btrfs-prog.

  something like
   btrfs get stime <snapshot>

Cheers, Anand
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
