Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbcDFDLI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 23:11:08 -0400
From: NeilBrown <neilb@suse.de>
To: Shaohua Li <shli@kernel.org>, Lars Ellenberg <lars.ellenberg@linbit.com>
Date: Wed, 06 Apr 2016 13:10:57 +1000
Cc: Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix potential access after free: return value of blk_check_plugged() must be used schedule() safe
In-Reply-To: <20160406004956.GA102852@kernel.org>
References: <20160405133657.GA3078@soda.linbit> <20160406004956.GA102852@kernel.org>
Message-ID: <87k2kbo2im.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 06 2016, Shaohua Li wrote:

> On Tue, Apr 05, 2016 at 03:36:57PM +0200, Lars Ellenberg wrote:
>> blk_check_plugged() will return a pointer
>> to an object linked on current->plug->cb_list.
>>=20
>> That list may "at any time" be implicitly cleared by
>> blk_flush_plug_list()
>>  flush_plug_callbacks()
>> either as a result of blk_finish_plug(),
>> or implicitly by schedule() [and maybe other implicit mechanisms?]
>>=20
>> If there is no protection against an implicit unplug
>> between the call to blk_check_plug() and using its return value,
>> that implicit unplug may have already happened,
>> even before the plug is actually initialized or populated,
>> and we may be using a pointer to already free()d data.
>
> This isn't correct. flush plug is never called in preemption, which is de=
signed
> only called when the task is going to sleep. See sched_submit_work. Am I
> missing anything?

Ahh yes, thanks.

Only two places call blk_schedule_flush_plug().
One is io_schedule_timeout() which must be called explicitly.
There other is, as you say, sched_submit_work().  It starts:

static inline void sched_submit_work(struct task_struct *tsk)
{
        if (!tsk->state || tsk_is_pi_blocked(tsk))
                return;

so if the task is runnable, then as
include/linux/sched.h:#define TASK_RUNNING              0

it will never call blk_schedule_flush_plug().

So I don't think you are missing anything, we were.

Lars:  have your concerns been relieved or do you still have reason to
think there is a problem?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXBH5BAAoJEDnsnt1WYoG5taIP/2PjshEshFan0ldx2ZC371dK
VfHvoqQEVQS+XwxQJjGEblNjggNZfE2mdFM4LLRyn+Rc2D0ZKAFlingKVXMkAhXO
rjbcxJZD0H3hbWnMLGqQsnkyWXIsbP9Ci2iAxtogM2AyHzvTSQXMYfT7QWJ5iTIy
zcxmJq03dl2iA+jvnhzFl+gt+nVXL8Ual3mu2FBgJr89+lsgPWzRY4yyiC6ldjWp
z6zE6muE1rzBcJKOTt3y4WRuiIfXb4h3JWUxs3WKzLaMEsZLfVv2CYWKQ8mfoh7j
QdhJUE7yj7wIqhfzwfSjvAnG329iJkunmVuMkeSxtwn0CUErkInLGw6segzUMSyX
B3TKnF1lSuLKsIYd3QttwPLMkJ3yMPUr4FJxMXQ1WpHw69ZkOnYkJg2XR9JKnLiw
FZQ79bvb/X8Vqcr9RWeMKEJKM1NEwC852PJNI+QU4l8mgyzHv3Ip9UJIfTzGqW2Y
e5TLrJqNqczxOhTuEW8GPFsht1gjtWNYcDb84Q0NBnI0glrKg7KHaOsZrKFOTppN
i+UXRB1ieQXvZdvd9NxXJk1A+616BO8h4MuFaOb1HcTRb9PoM7NDmXo3SpBOnvGs
LdXxCGKBk1UvacgI4artOb6UVPGw/KAz0dsAdbdLYJtkTHkfqmXdKc/JlMt+YYPg
ECz/B0xdLmTjZgU+NKX2
=8JgF
-----END PGP SIGNATURE-----
--=-=-=--
