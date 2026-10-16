Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666BE2D5432
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792110738; cv=pass; b=krELXaylov299fE4fU9EubPExhxKGINJApigMFp9uB0b7JpJv4CnRG9u5BvAfvYJbPTTzyM87otjDNGbIm1e75BaJTEaYAyFlJ2iGIFXAX0X0OsMvkj0FuenqWOcO11D3UdKHtJfT3xOpCeqef8Oh/zvsw2zZv8UtwBQDGnSFV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792110738; c=relaxed/simple;
	bh=HxZt08dVRw4ejTWE+FGXV5r0nmHjM+0lQhVW4+dpeTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pUvj4PBuBjwDMQpIoywm9+JZLd9VH4uJmTS9xguFuSq+5/aMj1pt52uXvm3K8WL09Qcy8vbEu2Cny57dobYONGC26SJ5RyKWVg14HAbgGmAUqyIxjaIOjbMDGVW+wtnjSQo9WKNvJ1cwl185ebdp2jmZm4IMpua7gMwPWTmATEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OMi03vrw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=e44as47a; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OMi03vrw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="e44as47a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792110735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PpmzonvJ+GFyXX1ccvr8BDAPumMVPYHB7D08eoJkdk=;
	b=OMi03vrwiksem2U41TCFBpUAaYtOZu+lGZOzQNCPnbZbJzhol7uqK7YGClwnyJrFYP7ZvB
	XuiMXVbpxX9CP5a1piIHy0xC5qZ6xdSYcBrXoms3/U4sR8cR+kr8KrpKQcTPzttb0PiRWY
	wj4ZU8y3W/z/IQVJFmLs9cARieZ3mzo=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-39wfngvqPiSazclSbrO7vg-1; Fri, 16 Oct 2026 00:32:14 +0000
X-MC-Unique: 39wfngvqPiSazclSbrO7vg-1
X-Mimecast-MFC-AGG-ID: 39wfngvqPiSazclSbrO7vg_1792110734
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-679a95932e5so997553d50.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 17:32:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792110734; cv=none;
        d=google.com; s=arc-20260327;
        b=K56DmMm0advkF62IfEqwsPkPVgHyRk6Io5Ed14NftfEQaSSh0bRSTZIHnBHN+Kdpby
         mlxtPrOXiGclyR5vvTzzXyC+fZj3LvmDuDyrlUhv2rMgqX08S77eqMfzFAzO3LBTmRzB
         EIP8LXiFT2+NLtq9pmrppH/GImsFnnCPoLNo7vNnrl+Mnh11kwwA2krgF69icK9+pIMl
         ayvp0uyoO2rEsdti2c7VqeL7yoZfTd0akUY6km5Fau0DF+WD2uqdKQW8+UICJxlUFb3b
         Susj5Et2YuMpix0xqza8YrbsEuh4F9htzKbIbyKx7dCiV5SUVrCFYnS81EphD10uKO2C
         5TLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2PpmzonvJ+GFyXX1ccvr8BDAPumMVPYHB7D08eoJkdk=;
        fh=ALl0UZl32lo0czAnCpUYDFeAnAARXFafpjmuzIHdb7g=;
        b=s0BL5d9guZj3C7yqr0NXhrlUz2lYi+YS4DYKbKHGbXVHdrmxZ33ePl0JDjM8EqtKhz
         GBf9DievXCMM27ubTVk2c2WnVlFKR4t2Zh0Sq1VXEZIow3WHKWIH+pAS4+HULeJBYQ4s
         DMUv9Pd4q/zsnryDeBz1zOFzANTsDS9PiGzg5vWvfEdOGF3k15Mcn97OTcnleOeNdHuT
         /b2VoDWzGCEvrjttZUHNbB8gie2hLEvRbt/ufk/6Vuecnvgb8y457OL7qaM2epd5n+2u
         8tcoOBkd0cNOYEaTFYxeBSD0PDb28vUaahaZuAhsJL1qHyyyG8EzpyFuTnjHg+KPd3cH
         ftEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792110734; x=1792715534; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2PpmzonvJ+GFyXX1ccvr8BDAPumMVPYHB7D08eoJkdk=;
        b=e44as47akmOsgAPYcknFZDeg1n+1fksH0OC6q+59eH7+pcKoxydRRxC0idRYHM5NQc
         pXF682olydeLFxDUYv+HFwqIFvT1H/39wwC+qJLMVOAx6nyjvB33b0JwJg1luxVVmy7J
         bQ1NZQUZGfEnSkswYB0xN9wbtSWkn9E94StoPwU2WZiWOpLl24b0gvqRaKM66Fm7BAfR
         A8/t9LHJrUvXXT11jmK5oJfdZGjRICkIrK0giarBTel8bpjIBUbME3vgRwWfvoTrblNX
         axhf7+SaVPxYw8Hb/owFdnHFiMIlByRs+KQqskNtARxda3UYQWLxDZaH83/ggptApHfe
         tY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792110734; x=1792715534;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2PpmzonvJ+GFyXX1ccvr8BDAPumMVPYHB7D08eoJkdk=;
        b=1xv9+wHn9TobGdHvoc8olYkRRjFxWSgvf8E7qfzrECL+BnOyf3wgkubbsVOp3h2CDN
         t7z5NpKWCyVwJtRpuZ0PGRA2J4k2B/1KN9uTfMyshkEd5ciofWkA/ZbrpaLDyVdNkBxx
         U4MOx27QZY9/MZRvWZ5GWo4Qns5C1lsHNm/OfIWn+L6xdhS6yx58AYyRydNvpC8PhTAG
         3JvmcCCZKSTHVsw4RnqORXYcifLDXmSfZE0aPVnuQNBHh5gyRbo5JD+jCYcxCvmzF0P0
         CDgZFE36MDr9pqxbUdlN6Bj3vGL2MtT4+5ywumAT7D4yJJchi0s8rQ76jiz3UEV9eM3r
         UzeQ==
X-Forwarded-Encrypted: i=1; AKwUvBwmvBvx87szfC25HZseMapyPoGqCBM/H3sYyfJKkVu4MbdvvyZYcz2RFXJ/bf/keZTm0B3dQDHhsT8dYw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIzH7kwzo7KJ4nkpMjN90WqiwSqrv9PDkFngaqTQVJ74WblnE65
	fNfbPE5+RwRe+7caxSxVDyrXAz/w5lO8ZlnULcmqKsf3pj5G7NshTJEA6NuZTvHezFDqZSN9UjM
	PZhtNjGEziGNY5YEI4nwcytoSaBB74g+7HYD9Ag+R04e1bhBWkB/dn8bLbQqoSr8Ooj/qOq0qXb
	DpVRe248ZdzLYLBWcwni7SQHL6i4ObnHSsGtCS1Fk=
X-Gm-Gg: AYBFou1lySxuQCMKfIBLU7KFPQNmdTUz1qdEijzMOgysPukfuytaR2j3m5upXJjmH11
	y1pf9Bjs2JV8enBI/NXYVQyXGzH/HINe2l66LdZT6WQAPD8q7oAiesNnIocUigUoQJd1D9KTfb3
	owxMZCesulkCJvGTbU/Q9O36ge9NRM9SBlJDfHwRF48oCN3kvpXvlJrkFLd0JRm97LMvE6m+Xuu
	S10+y7qDNBpHYz/xq368ZkQNIj0SQtmm581nYS4qT/hfA==
X-Received: by 2002:a05:690e:12cf:b0:677:c92e:eee4 with SMTP id 956f58d0204a3-67936ac0905mr8161304d50.86.1792110733224;
        Thu, 15 Oct 2026 17:32:13 -0700 (PDT)
X-Received: by 2002:a05:690e:12cf:b0:677:c92e:eee4 with SMTP id
 956f58d0204a3-67936ac0905mr8161290d50.86.1792110732554; Thu, 15 Oct 2026
 17:32:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org> <20261012-work-fs-sb_rdonly-v1-20-60743a3dc326@kernel.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-20-60743a3dc326@kernel.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 16 Oct 2026 02:32:01 +0200
X-Gm-Features: AclHuK8NmKT3H02cx2l9pkluaZaWRnSiR4jZEUSx8b1tH5UXdD0FGyrgWytahmA
Message-ID: <CAHc6FU5bdAjABRm=bnH68b2f66TZTDZ8sPdatLB2fS7-55U=yw@mail.gmail.com>
Subject: Re: [PATCH RFC 20/28] gfs2: wait for a pending withdraw before
 remounting read-only
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christian,

On Mon, Oct 12, 2026 at 1:27=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> Since commit 9c4a3de6cd5b ("gfs2: Asynchronous withdraw") most of a
> withdraw happens in do_withdraw() from a work item and SDF_JOURNAL_LIVE
> stays set until it ran. A remount to read-only in that window goes
> through gfs2_make_fs_ro(). Its log flushes bail out early on the
> withdrawn filesystem before FLUSH_SHUTDOWN can clear SDF_JOURNAL_LIVE
> and then gfs2_quota_cleanup() hits its BUG_ON():
>
>   kernel BUG at fs/gfs2/quota.c:1532!
>   RIP: 0010:gfs2_quota_cleanup+0x562/0x6b0
>    gfs2_make_fs_ro+0xf3/0x2e0
>    gfs2_reconfigure+0x42e/0xfd0
>    reconfigure_super+0x437/0xb20
>
> Just flushing the withdraw work before the remount isn't enough.
> gfs2_withdraw() sets SDF_WITHDRAWN, calls dump_stack() and only then
> queues the work. So a remount can see a withdrawn filesystem while
> there's nothing to flush yet. And a withdraw can also start in the
> middle of gfs2_make_fs_ro().
>
> So let do_withdraw() wake up waiters when it clears SDF_JOURNAL_LIVE and
> let gfs2_make_fs_ro() wait for the bit after its log flushes, right
> before gfs2_quota_cleanup(). On a healthy filesystem the shutdown flush
> already cleared it. umount doesn't need to wait. gfs2_put_super() sets
> SDF_NORECOVERY first and gfs2_quota_cleanup() only BUGs without it. Once
> the bit is clear the journal isn't live anymore and gfs2_make_fs_ro()
> doesn't write anything.
>
> gfs2_make_fs_rw() can leave the bit set on a withdrawn filesystem as
> well. It checks for a withdraw and then sets SDF_JOURNAL_LIVE. If
> do_withdraw() runs in between it finds the journal not live yet and
> returns. Nothing clears the bit then and the next remount to read-only
> waits for it forever. So check for the withdraw and set the bit under
> sd_log_flush_lock, which do_withdraw() holds while it tests the bit.
> Then either the remount sees the withdraw or do_withdraw() sees the live
> journal.
>
> Reproducer, lock_nolock: a SCHED_FIFO task writes 1 to the withdraw
> sysfs knob from cpu 1 and keeps cpu 1 busy (RT throttling and cpu 1's
> fair server disabled) so do_withdraw() can't run, then from cpu 2:
>
>   mount -o remount,ro /mnt
>
> On lock_dlm the window lasts as long as the withdraw helper runs. The
> window before the work is queued can be widened with a kprobe on
> dump_stack_lvl() that delays the task writing to the withdraw knob by a
> few seconds. A remount to read-only or sysrq u in that window hits the
> same BUG_ON().
>
> Fixes: 9c4a3de6cd5b ("gfs2: Asynchronous withdraw")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/gfs2/super.c | 22 ++++++++++++++++++----
>  fs/gfs2/util.c  |  2 +-
>  2 files changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> index 06302c29340f..1d7b39354d65 100644
> --- a/fs/gfs2/super.c
> +++ b/fs/gfs2/super.c
> @@ -147,12 +147,23 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
>         }
>
>         error =3D gfs2_quota_init(sdp);
> -       if (!error && gfs2_withdrawn(sdp)) {
> -               gfs2_quota_cleanup(sdp);
> +       if (error)
> +               return error;
> +
> +       /*
> +        * do_withdraw() only takes a live journal down. Check for a with=
draw
> +        * under the lock it holds for that so that either we see the wit=
hdraw
> +        * or it sees the journal live. Otherwise gfs2_make_fs_ro() waits=
 for
> +        * the bit forever.
> +        */
> +       down_write(&sdp->sd_log_flush_lock);
> +       if (gfs2_withdrawn(sdp))
>                 error =3D -EIO;
> -       }
> -       if (!error)
> +       else
>                 set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> +       up_write(&sdp->sd_log_flush_lock);
> +       if (error)
> +               gfs2_quota_cleanup(sdp);
>         return error;
>  }
>
> @@ -565,6 +576,9 @@ void gfs2_make_fs_ro(struct gfs2_sbd *sdp)
>                                    HZ * 5);
>                 gfs2_assert_warn(sdp, gfs2_log_is_empty(sdp));
>         }
> +       /* A withdraw that do_withdraw() didn't finish yet leaves it live=
. */
> +       if (!test_bit(SDF_NORECOVERY, &sdp->sd_flags))
> +               wait_on_bit(&sdp->sd_flags, SDF_JOURNAL_LIVE, TASK_UNINTE=
RRUPTIBLE);
>         gfs2_quota_cleanup(sdp);
>  }
>
> diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
> index 83b8bb6446e5..1535ce2b7aa8 100644
> --- a/fs/gfs2/util.c
> +++ b/fs/gfs2/util.c
> @@ -122,7 +122,7 @@ static void do_withdraw(struct gfs2_sbd *sdp)
>                 up_write(&sdp->sd_log_flush_lock);
>                 return;
>         }
> -       clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
> +       clear_and_wake_up_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
>         gfs2_ail_drain(sdp); /* frees all transactions */
>         up_write(&sdp->sd_log_flush_lock);
>
>
> --
> 2.53.0
>

this looks good all around, thank you very much. Can I add it to my gfs2 qu=
eue?

Thanks,
Andreas

