Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48246 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab3K0QYo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 11:24:44 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so10770035pbb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 08:24:44 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 27 Nov 2013 18:24:44 +0200
Message-ID: <CAHFzjDB3E0AxAL757GZYoLwie=cqwLNZURPTcvZtcGAtVyEg5g@mail.gmail.com>
Subject: BTRFS incompatible with different page sizes
From: Ronen Shitrit <rshitrit@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: clinew@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

BTRFS filesystem is incompatible with architectures such as PowerPC
and MIPS which have a page size larger than 4k, Meaning that using a
formatted FS on machine with 64K page size will not be mounted on a
machine with 4K page.

I have noticed this remark in the wiki:
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Different_sector_sizes
and the WIP patch there.

Can someone please update what is the status on this? Is someone working on it?

I can suggest to try and pick this up, if people are interested in
this solution.

Regards
Ronen Shitrit
