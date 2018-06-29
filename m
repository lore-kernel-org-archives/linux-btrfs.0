Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:42063 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932140AbeF2DZP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 23:25:15 -0400
Received: by mail-ot0-f181.google.com with SMTP id n24-v6so8465045otl.9
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 20:25:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55c3e4a3-c7c4-0f4b-9767-7eeccd733cae@gmx.com>
References: <20180628070443.23421-1-wqu@suse.com> <c5fc1287-cf27-75c0-3175-33d71014fe78@suse.com>
 <55c3e4a3-c7c4-0f4b-9767-7eeccd733cae@gmx.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Thu, 28 Jun 2018 23:25:14 -0400
Message-ID: <CA+X5Wn4a2sPjaYhU5qp9XCO5CKyP9mzsFh45yZ_V8fjcFmg4Uw@mail.gmail.com>
Subject: Re: [PATCH RFC] btrfs: Do extra device generation check at mount time
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 28, 2018 at 3:15 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> I'd like to make sure everyone, including developers and end-users, are
> fine with the restrict error-out behavior.

Yes, please error out, as a start.  Requesting this was on my
btrfs-to-do list.  A device generation mismatch from a drive going
offline until forced reboot was what ultimately sent me on the path of
problems I had.  Had parent transid errors, which I realized was due
to this, and decided to replace the outdated lvm partition with a new
one.  (Hiding the bad one to prevent UUID problems of course.)
