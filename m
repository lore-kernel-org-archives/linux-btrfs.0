Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35211 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbcETPVF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 11:21:05 -0400
Received: by mail-oi0-f67.google.com with SMTP id w198so24406249oiw.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 08:21:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463719498-2057-1-git-send-email-fdmanana@kernel.org>
References: <1463719498-2057-1-git-send-email-fdmanana@kernel.org>
Date: Fri, 20 May 2016 11:21:04 -0400
Message-ID: <CAEzrpqcc-KTLJQvu1nvrprEVLudShW=paJmLKTcmP2g8ixeXvA@mail.gmail.com>
Subject: Re: [PATCH 4/6] Btrfs: fix unprotected assignment of the left cursor
 for device replace
From: Josef Bacik <josef@toxicpanda.com>
To: fdmanana@kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2016 at 12:44 AM,  <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> We were assigning new values to fields of the device replace object
> without holding the respective lock after processing each device extent.
> This is important for the left cursor field which can be accessed by a
> concurrent task running __btrfs_map_block (which, correctly, takes the
> device replace lock).
> So change these fields while holding the device replace lock.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Eesh, thanks,

Reviewed-by: Josef Bacik <jbacik@fb.com>
