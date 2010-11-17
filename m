From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: do not loop through raid types when looking for
 free extent
Date: Wed, 17 Nov 2010 09:38:23 +0800
Message-ID: <AANLkTikXh1di6qoN5EgCdbH+20ZCzSdOD8UcXja-Sn_c@mail.gmail.com>
References: <1289942524-29637-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289942524-29637-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 17, 2010 at 5:22 AM, Josef Bacik <josef@redhat.com> wrote:
> There is a bug in find_free_extent where if we don't find a free exte=
nt in the
> raid type we are looking for, we loop through to the next raid type. =
=A0This is
> not ok since we need to make sure we honor the raid types we are give=
n. =A0So
> instead kill this check and get the proper index for the raid type we=
 want from
> the allocator. =A0Thanks,
>

Loop through raid types is for handling failure in the middle of raid t=
ype
conversion.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
