Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37348 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2GELvu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 07:51:50 -0400
Received: by pbbrp8 with SMTP id rp8so12675070pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2012 04:51:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341409108-13567-5-git-send-email-ablock84@googlemail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-5-git-send-email-ablock84@googlemail.com>
Date: Thu, 5 Jul 2012 13:51:49 +0200
Message-ID: <CAB9VWqA4GpC8BHiKbYzX+=GhTvj_wSGH0ByfYtpbP8Ww9aAdRQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 4, 2012 at 3:38 PM, Alexander Block <ablock84@googlemail.com> wrote:
> This patch introduces uuids for subvolumes.
> [...]
Stefan and Jan pointed out a problem with this patch that would result
in read_extent_buffer calls that read beyond the leaf size when an old
root item is found at the end of a leaf. I pushed a fix to github that
tries to replace read_extent_buffer calls with a new helper function
(btrfs_read_root_item). The patch also adds a __le64 reserved[8] field
to the root_item struct, which means that when you apply that fix all
your extra information in the root items will get lost on next mount.

As already said in the cover letter, I will not send patches to the
list before it's worth for version 2. Such fixes are only found in my
git repo and will later be squashed together for v2.
