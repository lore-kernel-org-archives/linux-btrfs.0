Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36680 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbcCKWTd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 17:19:33 -0500
Received: by mail-wm0-f54.google.com with SMTP id n186so36583863wmn.1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 14:19:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457608215-18089-1-git-send-email-alex@zadarastorage.com>
References: <1457608215-18089-1-git-send-email-alex@zadarastorage.com>
Date: Fri, 11 Mar 2016 17:19:31 -0500
Message-ID: <CAD=QJKhYurWnNrXunX+_=KYamdTqnZ2tzO7_+gFxv12c1bd1Hg@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: do not write corrupted metadata blocks to disk
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 March 2016 at 06:10, Alex Lyakas <alex.bolshoy@gmail.com> wrote:
> csum_dirty_buffer was issuing a warning in case the extent buffer
> did not look alright, but was still returning success.
> Let's return error in this case, and also add an additional sanity
> check on the extent buffer header.
> The caller up the chain may BUG_ON on this, for example flush_epd_write_bio will,
> but it is better than to have a silent metadata corruption on disk.

Does this mean there is a good chance that everyone has corrupted
metadata?  Is there any way to verify/rebuild it without
wipefs+mkfs+restore from backups?

Best regards,
Nicholas
