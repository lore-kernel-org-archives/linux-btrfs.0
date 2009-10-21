From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: btrfsck aborts after transid verify failed?
Date: Wed, 21 Oct 2009 15:47:42 +0800
Message-ID: <3d0408630910210047q6021e957n8f84ad611eabb528@mail.gmail.com>
References: <4ADEA4B6.8050001@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: John Dong <jdong@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ADEA4B6.8050001@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2009 at 2:05 PM, John Dong <jdong@ubuntu.com> wrote:
> This is a fairly stock Ubuntu Karmic install within a VMWare session,
> converted from ext4 via btrfs-convert out of git, and also btrfs.ko c=
ompiled
> out of git.
>
> A btrsfsck run after removing the ext2_saved image yielded the follow=
ing:
>
> parent transid verify failed on 17092046848 wanted 9067 found 8931
> btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node=
)'
> failed.
> [1] =A0 =A02252 abort (core dumped) =A0sudo btrfsck /dev/sda2
>

Did you run btrfsck on mounted FS ?

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
