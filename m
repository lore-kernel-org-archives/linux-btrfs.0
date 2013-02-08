Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:39496 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3BHVaG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 16:30:06 -0500
Received: by mail-la0-f45.google.com with SMTP id er20so4245798lab.18
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2013 13:30:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAM-0MpVDJ+TGC6x9JHd+wG5dsACdN4Y+JFgksQCsiwzGQYNanA@mail.gmail.com>
References: <CAM-0MpVDJ+TGC6x9JHd+wG5dsACdN4Y+JFgksQCsiwzGQYNanA@mail.gmail.com>
Date: Fri, 8 Feb 2013 22:30:04 +0100
Message-ID: <CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
Subject: Fwd: Current State of BTRFS
From: Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

I am using btrfs as my main fs for some time now, but I am
experiencing severe performance drawbacks. I can't qualify the
circumstances, but sometimes during disc access the whole system
freezes for some time.

Maybe somebody could suggest some general things I could try to search
for the problem?

Thanks in advance,
Florian

---

Some background information:

$ mount | grep btrfs
/dev/mapper/sda2crypt on / type btrfs (rw,relatime,compress=lzo,space_cache)

Hmm ... couldn't think of more :(
