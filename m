From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: fix another orphan cleanup problem
Date: Tue, 26 Jan 2010 12:19:40 +0800
Message-ID: <3d0408631001252019l253c1251r7dd501196dbcca41@mail.gmail.com>
References: <20100125210147.GB2204@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100125210147.GB2204@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 26, 2010 at 5:01 AM, Josef Bacik <josef@redhat.com> wrote:
> Because orphan cleanup now happens well after the fs is all initializ=
ed and
> such, we can run into this problem where we find orphan entries that =
were just
> added to the fs, not ones that were added previously during a crash. =
=A0This does
> not bode well for the system, and results in a couple of odd things h=
appening,
> like truncate being run on non-regular files. =A0In order to fix this=
 we just
> check and see if the inode has been added to the in-memory orphan lis=
t, and if
> it has, set the key to it's inode number - 1 so we don't find this or=
phan entry
> again, and continue searching.
>
> This problem kept popping up while running xfs tests, and was 100%
> reproduceable. =A0With this patch the problem no longer happens. =A0T=
hanks,
>

Hi Josef,

I think this problem was introduced by your previous orphan cleanup fix=
=2E
Before I introduced the orphan cleanup regression, orphan cleanup on
a subvol was triggered by the first access. Your previous orphan clean =
fix
broke this rule, orphan clean is triggered when the first time btrfs_lo=
okup
finds a valid inode. I think it's better to keep the old rule. revert y=
our
previous changes and add code to open_ctree() to do orphan cleanup for
the default subvol.

Regards
Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
