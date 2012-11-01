Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64810 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab2KAB2G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 21:28:06 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so792610eaa.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 18:28:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvi0jLAm_pp0YzD=o2W86jrPSnNw3Z+3UFq9ZY1joynCew@mail.gmail.com>
References: <CANmUDYsPqS9ZUVWhzxQv4G6fkQaRbGa2M3TTECp+tujJtyN4EA@mail.gmail.com>
	<CAE5mzvi0jLAm_pp0YzD=o2W86jrPSnNw3Z+3UFq9ZY1joynCew@mail.gmail.com>
Date: Wed, 31 Oct 2012 17:28:05 -0800
Message-ID: <CANmUDYuTLu5M7PAG1_w2bPORMs73yRmfSc0-2Wx7+UU+FPbs-w@mail.gmail.com>
Subject: Re: find-new possibility of showing modified and deleted files/directories
From: Shane Spencer <shane@bogomip.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's Plan B.  I'll be making a btrfs stream decoder and doing in
place edits.  I need to move stuff around to other filesystem types
otherwise I'd just store the stream or apply the stream to a remote
snapshot.

On Wed, Oct 31, 2012 at 4:13 PM, cwillu <cwillu@gmail.com> wrote:
> Probably easier to decode the btrfs-send stream, or even just use btrfs-send
> itself instead.
