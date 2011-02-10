From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 15:05:23 +0100
Message-ID: <AANLkTimab4hgbh40YZ-wd2BHc7-SgxZN20q2GJt37RjO@mail.gmail.com>
References: <1297081322.4615.10.camel@monotop>
	<4D53C711.3000309@nsc.liu.se>
	<AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>
	<ij0iku$hbq$1@dough.gmane.org>
	<AANLkTi=7B1FLtSrcJ88zgitCBiRctwveRhLzt_2yAHZL@mail.gmail.com>
	<1297344585.28159.12.camel@monotop>
	<AANLkTik0stPo-_s-n8ndZUiwYcZ51V6m29x1X56q8AYd@mail.gmail.com>
	<1297345079.28159.14.camel@monotop>
	<AANLkTi=0wroct+WA7r6931NBhYBtdj7PjheVSFQYp3WE@mail.gmail.com>
	<1297346453.28159.17.camel@monotop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeremy Sanders <jeremy@jeremysanders.net>,
	linux-btrfs@vger.kernel.org
To: Eduardo Silva <eduardo.silva@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297346453.28159.17.camel@monotop>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 10, 2011 at 3:00 PM, Eduardo Silva <eduardo.silva@oracle.co=
m> wrote:
> On Thu, 2011-02-10 at 14:52 +0100, Olaf van der Spek wrote:
>> On Thu, Feb 10, 2011 at 2:37 PM, Eduardo Silva <eduardo.silva@oracle=
=2Ecom> wrote:
>> > string_copy seems pointless, it's kinda equivalent to strcpy.
>> >
>> > Yeah, but if we are thinking into write some wrappers let's create=
 a couple
>> > for the major string manipulation used...
>>
>> A wrapper should have a benefit, your string_copy doesn't have any.
>
> It have it, take this example:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0char *a;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0a =3D malloc(1024);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0strcpy(a, NULL);
>
> at least with the wrapper you will get a notice about what's going
> on...

The debugger shows you what's going on without wrapper.

--=20
Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
