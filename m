Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:43848 "EHLO
        smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751000AbdISSEc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 14:04:32 -0400
Date: Tue, 19 Sep 2017 21:04:24 +0300
In-Reply-To: <63fd4cdb-52d4-4aee-cc82-dbb7eba72a06@redhat.com>
References: <CAGqmi74kxPpkuYCBwfdyzxUKAHE6TP9x1FGDz0FURud21u=nOA@mail.gmail.com> <63fd4cdb-52d4-4aee-cc82-dbb7eba72a06@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: Does btrfs use crc32 for error correction?
To: Eric Sandeen <sandeen@redhat.com>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <A026785F-2C95-41B9-9D79-EE0672981C72@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Would be cool, but probably not wise IMHO, since on modern hardware you almost never get one-bit errors (usually it's a whole sector of garbage), and therefore you'd more often see an incorrect recovery than actually fixed bit.
-- 

With Best Regards,
Marat Khalili
