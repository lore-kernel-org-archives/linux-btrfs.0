From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH][btrfs-progs] Prevent a SIGSEGV by returning -1 from btrfs_search_slot()
Date: Thu, 19 Aug 2010 03:15:45 -0700
Message-ID: <AANLkTin600gFTYu4Ky711dY7zN8qesWgDo_v+f-sVZBy@mail.gmail.com>
References: <1282210136-3625-1-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1282210136-3625-1-git-send-email-surbhi.palande@canonical.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 19, 2010 at 2:28 AM, Surbhi Palande
<surbhi.palande@canonical.com> wrote:
> https://launchpad.net/bugs/601877
>
> btrfs_search_slot() returns
> * -1 when some error is encountered
> * +1 when the item to be searched is not found
> * 0 when the item is found successfully.
>

Any chance you can add some defines for these values?
