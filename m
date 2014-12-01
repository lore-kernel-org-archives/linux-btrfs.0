Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:58412 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaLAQlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 11:41:08 -0500
Received: by mail-qc0-f182.google.com with SMTP id r5so7964175qcx.13
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 08:41:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE8gLhnyTWjfTk-W+BHdfovV8pJH-yqo7joR+kf6vgs1FU00hw@mail.gmail.com>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org> <547C6922.6030206@gmail.com>
 <CAE8gLhmn3aX88t1FO2=BnHXk0-+2xQ4dnW57dga93iA-bFaUzQ@mail.gmail.com>
 <20141201184749.0fd67b62@natsu> <CAE8gLhnyTWjfTk-W+BHdfovV8pJH-yqo7joR+kf6vgs1FU00hw@mail.gmail.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Mon, 1 Dec 2014 22:10:46 +0530
Message-ID: <CAH-HCWWZ4FXHtb42dVOaKtLzmndc=e_LAqrufUZRt36CD_g34g@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
To: MegaBrutal <megabrutal@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Roman Mamedov <rm@romanrm.net>,
        Marc MERLIN <marc@merlins.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 7:24 PM, MegaBrutal <megabrutal@gmail.com> wrote:
>
>> If you want to make snapshots which can't be removed by ordinary tools, use
>> the 'read-only' mode when creating them.
>
> Yeah, good idea! Anyway, is it possible to change a read-only snapshot
> to read-write and vica-versa, or you can only specify read-only while
> creating them?

IIUC you can only specify RO while creating but you can always cheaply
create a RW snapshot of an RO one or an RO snapshot of an RW one...

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
