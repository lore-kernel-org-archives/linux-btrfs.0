Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36742 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbcHAQ1J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 12:27:09 -0400
Received: by mail-oi0-f49.google.com with SMTP id w18so199735289oiw.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 09:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRgmfWVf9YB2=fVLDSRhm4-t7W+YHBabBaBsBZeSiDU1Q@mail.gmail.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
 <ac28e105-f228-de18-08c2-e504e304052d@gmail.com> <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
 <a582564a-e991-dd35-721f-31c807a24929@gmail.com> <CAJCQCtRgmfWVf9YB2=fVLDSRhm4-t7W+YHBabBaBsBZeSiDU1Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 1 Aug 2016 10:22:05 -0600
Message-ID: <CAJCQCtR5TsrvDh566unaxk9J54a+Bbo7ydKxurpnF0UUh9B9xA@mail.gmail.com>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 1, 2016 at 10:19 AM, Chris Murphy <lists@colorremedies.com> wrote:

> So that makes me wonder how btrfs device add and remove will behave,
> if issued in a DE which is then logged out of. Those commands do not
> return to prompt until they complete.

Strike add. That's fast. I'm concerned about dev delete/remove and also resize.


-- 
Chris Murphy
