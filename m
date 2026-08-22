Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54483B8D7E
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 09:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787391484; cv=pass; b=AEYOEn318x08UCe6u8CZJsRk6/GhUkBIZIzqM0wGyGxcR9lCdGABTDSqRiakaP7NwACE/MckRxHajervETcIc4UE/IAqT7ognMPafx5XsQ3vUZU/Eit4nDDDwshJ3ozhbbtPpvJ73PjiziwmoI9/oUWl+rKdcmsWNdZE3rzPCM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787391484; c=relaxed/simple;
	bh=Zsg4yDWJEYnj+Dd3lyJCMVB/kRCOT/2xUO0vLkow4qU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wk+qa5X8evuSoqLz736OCb/pLfmcyrHAB19AvUXqGmX648QGKao6W6xx1IDFY1wEcIaJIx3pZQSpX7AIQBCpD8NTXsn05RdaK3yCIbk5tPEnH6/R2ksrlVp4xzklVFCwg2ugOWT+4iA71+Q6pqgdM3LF5ha7rYf1LFgWYy4kQMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ru13yIil; arc=pass smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ru13yIil"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so14720355e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Aug 2026 02:38:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787391481; cv=none;
        d=google.com; s=arc-20260327;
        b=DAHLgFZEyyDQJyGj6jN622gKCWHAI80BLNGWHmQtysn7VC/usjZJ6u3TP+6fFakr1p
         E19NKrlYDRNesMMAr8/u+WOv93sb7KkNQZJqhvz7dgQyS0IRKhyreev9XmQgesJUvks8
         Rik/KnjJHBi//QMNonq2Cux3q5JIXsButrccHO3azzOv0/fYyHxEx74B7W+Rg973gJFs
         1bz6JZ/eHGVYqBv6Xxh3qg5sw4dapcI8UUybZPuISisQROygUubdcdYDBPwc5qr1uw8G
         MBdPfITqC/2fuhx+tEvfaAx8MsbtLThxcF1w3LA7ZlpCXOrAD5Vnfd2I61I+vl1nbKZB
         B33g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ph2lPam8JCALxmYS0m0igrXYnBJnKWdV0o73cGjvg/Y=;
        fh=N/hhEiHcXy9ge6rGUXss48X+WvIh2oWckD3WsjgW82o=;
        b=fpHdNu7EUV36TYaDGso/r7kP2O0drAsWbyAQy3Y/zspDkKlreCTbyhlgrfSSkRa/vK
         Y+PwVfLzmIvv8BSEWs5TUvVSwPksA983LjC8v98mJMX5EcMaKI1QB1N9ioeWgQspMKhG
         9BC8WPbCfEPtatWStL5ORHAFYRioFIPWz4jwGjuxLSJjCNdwh6oFaaxzoV6b7Vv5lFl6
         HGr+kkZTcYKCI4Mh6xoxOo9ok3aw6m3UJTDPkH6ggYmg9MPhQtpCJQRdN5tZLUjPY4jC
         LCp5zkDgl/jKPUF9uJPnAho3BsLf3zpZZ0r5QNYy8AbTecMqsKr7HyPiGRVp/d49HlBI
         3uaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787391481; x=1787996281; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ph2lPam8JCALxmYS0m0igrXYnBJnKWdV0o73cGjvg/Y=;
        b=ru13yIilj3JSKtHFL4teOifmO3OFCJbf8ejySLOTHodnyuOjd6/raUQPIB0DaZex7f
         kBICjtmg+n6JOoc0NTXUUGZnsQlWTubTwonBxlFUZItduvcafekm1d1Kn9n6rGp+2Gd3
         eSutgN1T+Zn9nrGU+qA3uBQmAOvp3XAj44y0MAugI35ODxIqj5VHWQFrb5X6FNF8uxTb
         dipV1KQ7ad0L3gKIfzAS/ludCAYRDyfksggheUG/mp80mdU1FYTvPpy2ynG+M03N6Gft
         I/YYaR4P19EkjTwFpCGmHh6KEPDGfaXo1g0R/hqenwcC+vFGqi5FukeH6LGp+BzxFzo4
         hLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787391481; x=1787996281;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ph2lPam8JCALxmYS0m0igrXYnBJnKWdV0o73cGjvg/Y=;
        b=ZA5nE+YOkPIkmMoYH0k2SPM4JGiUnp8gbiDu9H+oqOo4qhJh97jB8YYIz5+YiDQj6v
         PKa6y+/h0MYjtc89H/yoUMHTA9pnkgfVLZIo0hLETcH5iAXreVuZV7tV3gfdWqGJnBnq
         48hWQmsnVgAZvxfqCL1KsNs58L28b31j70lLtMaGFN8PhG8FokCqyEatt83q2TxxwCOz
         DMFOavd5S8OWKkGjZrSL/Lt7H3pj9TQ95xiI5HB+jQrdsdrilFUwyjNnrcRt4h5IKMdC
         Y2cO3ZCBnKouiWOkF+XPts4+7LUpi85xPSh3gIo0bLDW67xS+kYA1KwPbc9oxwERG4UN
         /lhA==
X-Forwarded-Encrypted: i=1; AHgh+RpOfVynQIr7x2szzES9qE7gpteUACk1aS/UPgutpMYG/CWW0nrNpxr9o4NSvTC/ZKdsL6ygwOURlaQLtw==@vger.kernel.org
X-Gm-Message-State: AFuF++lzldNMbp0Nxb8VlTiHYwNLLLk6pbZmqlyT8zBw/mNS0I/c1TRj
	EKLBkp3lyo3piWlEb4WR0zBzLq4AyS7CXkGCIwX148Soo9pRp3U/E3I0XDbcms/Z1/krEks4eYC
	O9AJ1gVSZjmv6LEMWgq4dmpcZ58F29w==
X-Gm-Gg: AR+sD13ftTnE4mu5wRAjK1Z2H60Vk2/gqnf2xxkZfUhjxzkbYgI+Kal0CojeIVpXpL5
	WdXsdlGwOi4geT4tuPb2pNdUkYPTmZmmSJUyKV2oegMMWbGxVl5S/GauY+oI5k1D8MSRkBwECGx
	zbf76REtnNwAM033zDfd5m8VWIHWC46IHhDrd/liX1adhkQxU2cVciz5LVVG9sES4K7+n09BEvG
	NNYvF0iq1WeapHmqtUPGxUR1LSGmjZFtsTRBfsBvUEuXNbBfVwOnXPIueGxYsAttWSOav0uJzZT
	zkcKMD1PFJkNLo8gbCISlEftWLYzqisdGcT7sdu7d63vLNSUtv8TJl8=
X-Received: by 2002:a05:600c:c170:b0:495:7a04:b006 with SMTP id
 5b1f17b1804b1-499b832672fmr175520655e9.8.1787391480771; Sat, 22 Aug 2026
 02:38:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821-btrfs-zstd-lost-wakeup-v1-1-84f358d4ea67@gmail.com> <217f5236-e34d-46bb-97d7-2429f7a74ff6@suse.com>
In-Reply-To: <217f5236-e34d-46bb-97d7-2429f7a74ff6@suse.com>
From: old king <fy15309206903@gmail.com>
Date: Sat, 22 Aug 2026 18:37:49 +0900
X-Gm-Features: AcwNN1XisVAqkXIThFywb8dcxcPdDV3SrluGgPtqafyQKy5wKZYFSZMgmy-92x0
Message-ID: <CAMMY3OVONaSa7xpFrVFGzUkYUefEkF7eTmx1n96n0Ux+=RcqqA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: zstd: fix lost wakeup when waiting for a workspace
To: Qu Wenruo <wqu@suse.com>
Cc: Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, my two earlier replies went to you only and never reached linux-btrf=
s.

> This is the typical LLM behavior, if your human brain can not examine
> every possibly wrong conclusion/fix from LLM, LLM will only waste time
> of everyone.

Thanks for the review.

The LLM told me the diagram is missing the line this patch adds. In
your Thread B there is
nothing between prepare_to_wait() and schedule(), which is the unpatched
sequence. The patch puts the re-check there:

        Thread A (last ws holder)  |        Thread B (new ws user)
-----------------------------------+---------------------------------
zstd_put_workspace()               |
...                                               |
|- spin_lock_bh()                       |
|- spin_unlock_bh()                   |
|- cond_wake_up()                    |
   No one is waiting                   |
                                                  |- prepare_to_wait()
                                                  |
                                                  |  // THE CODE ADDED
BY THIS PATCH:
                                                  |- zstd_find_workspace()
                                                  |  WS IS FOUND HERE!
                                                  |
                                                  |  // schedule() is NOT c=
alled
                                                  |- finish_wait()

The interleaving you describe is the one the patch handles: if cond_wake_up=
()
sees an empty queue, thread A's list_add() has already completed, so the
zstd_find_workspace() after prepare_to_wait() finds that workspace.

The reverse order is covered by the barriers. prepare_to_wait() queues the
waiter and then calls set_current_state(), which is a full barrier;
cond_wake_up() -> wq_has_sleeper() has the matching smp_mb() before it read=
s
the queue. Either A observes the waiter and wakes it, or B observes the
workspace and does not sleep. That is the pattern wait_event() relies on.

Measured, same kernel image for both rows, the wait order selected by a
module parameter. QEMU/TCG, x86_64, 6 concurrent zstd:15 writers, failslab
restricted to the zstd_alloc_workspace() call stack via
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER (probability=3D100, times=3D1,
ignore-gfp-wait=3D0), and an mdelay(400) widening the window between the fa=
iled
allocation and prepare_to_wait(). Two allocation failures are forced per
run, so two tasks sit in that window. Instrumentation counts a max level pu=
t
whose wakeup found an empty queue while a task was inside the window
(dropped), and a re-check after prepare_to_wait() that returned a workspace
(recovered):

                        | dropped | recovered | result
  ------------------+---------+-----------+--------------------------------=
-
  unpatched     |   136   |       -       | hang, kworker/u16:0:12 blocked
                        |            |               | >122s in
zstd_get_workspace()
  patched         |   140   |       2      | no hang

The wakeups are dropped in both rows, in the window your diagram describes.
The difference is what happens next: in the patched row the two tasks that
would have slept find a workspace in the re-check and never reach schedule(=
).
One of them is the pid that hangs in the unpatched row.

The LLM assistance is the one already declared in the Assisted-by tag. The
reasoning above is checked against the code and against these numbers.

On Sat, Aug 22, 2026 at 5:01=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/8/22 03:20, FAN YE via B4 Relay =E5=86=99=E9=81=93:
> > From: FAN YE <fy15309206903@gmail.com>
> >
> > A writer can sleep forever in zstd_get_workspace() even though a worksp=
ace
> > is free.  When zstd_alloc_workspace() fails, the task is queued on
> > zwsm->wait and schedules unconditionally, never re-testing the pool.
> > zstd_put_workspace() publishes the workspace and then calls cond_wake_u=
p(),
> > which only wakes when a sleeper is already visible, so a workspace retu=
rned
> > between the failed allocation and prepare_to_wait() wakes nobody.  The
> > window is wide: zstd_alloc_workspace() goes through kvmalloc() and may
> > enter reclaim.
> >
> > Only a max level workspace triggers the wakeup and one is deliberately =
kept
> > allocated as the fallback every waiter waits for, so once its wakeup is
> > lost the writer stays in TASK_UNINTERRUPTIBLE until some other task hap=
pens
> > to return one.  Re-check the pool after prepare_to_wait() has published=
 the
> > waiter, and use the workspace if one turned up.
> >
> > Fixes: 3f93aef535c8 ("btrfs: add zstd compression level support")
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: FAN YE <fy15309206903@gmail.com>
> > ---
> > Reproduced under QEMU/TCG: CONFIG_FAULT_INJECTION_STACKTRACE_FILTER for=
ces
> > zstd_alloc_workspace() to fail exactly once and widens the pre-wait win=
dow
> > to 400ms while six concurrent zstd:15 writers race it. Unpatched, a
> > btrfs-delalloc kworker hangs in zstd_get_workspace()'s schedule() (hung=
_task
> > warning, >120s); the identical race against the patched code does not h=
ang.
> > Compile-tested (W=3D1, x86_64 defconfig + CONFIG_BTRFS_FS=3Dy).
> > ---
> >   fs/btrfs/zstd.c | 11 ++++++++++-
> >   1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> > index 86919293fd54..cb15cbd737c4 100644
> > --- a/fs/btrfs/zstd.c
> > +++ b/fs/btrfs/zstd.c
> > @@ -307,8 +307,17 @@ struct list_head *zstd_get_workspace(struct btrfs_=
fs_info *fs_info, int level)
> >               DEFINE_WAIT(wait);
> >
> >               prepare_to_wait(&zwsm->wait, &wait, TASK_UNINTERRUPTIBLE)=
;
> > -             schedule();
> > +             /*
> > +              * Re-check after being queued: zstd_put_workspace() only
> > +              * wakes a queue that already has a sleeper, so a workspa=
ce
> > +              * returned since the failed allocation woke nobody.
> > +              */
> > +             ws =3D zstd_find_workspace(fs_info, level);
> > +             if (!ws)
> > +                     schedule();
> >               finish_wait(&zwsm->wait, &wait);
> > +             if (ws)
> > +                     return ws;
>
> This doesn't work.
>
>          Thread A (last ws holder)  |       Thread B (new ws user)
> -----------------------------------+--------------------------------
> zstd_put_workspace()               |
> |                                  | zstd_get_workspace()
> |                                  | |- zstd_find_workspace()
> |                                  | |  No WS found
> |                                  | |
> |                                  | |- zstd_alloc_workspace()
> |                                  | |  Allocation failure
> |                                  | |
> |                                  | |- zstd_find_workspace()
> |                                  | |  Still no WS found
> |- spin_lock_bh()                  | |
> |- spin_unlock_bh()                | |
> |- cond_wake_up()                  | |
>     No one is waiting               | |- prepare_to_wait()
>                                     | |- schedule()
>                                     | |- finish_wait()
>
> This is the typical LLM behavior, if your human brain can not examine
> every possibly wrong conclusion/fix from LLM, LLM will only waste time
> of everyone.
> >
> >               goto again;
> >       }
> >
> > ---
> > base-commit: 531ed942bb0df04f6747983fecdedce76a22d07f
> > change-id: 20260821-btrfs-zstd-lost-wakeup-0b0ee88ed52f
> >
> > Best regards,
> > --
> > FAN YE <fy15309206903@gmail.com>
> >
> >
> >
>
