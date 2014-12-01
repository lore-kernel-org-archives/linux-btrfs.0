Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:59207 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344AbaLARTe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 12:19:34 -0500
Message-ID: <547CA31A.6070100@pobox.com>
Date: Mon, 01 Dec 2014 09:19:22 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>, MegaBrutal <megabrutal@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, Roman Mamedov <rm@romanrm.net>,
        Marc MERLIN <marc@merlins.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: Possible to undo subvol delete?
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com> <20141130042306.GE8916@merlins.org> <547C6922.6030206@gmail.com> <CAE8gLhmn3aX88t1FO2=BnHXk0-+2xQ4dnW57dga93iA-bFaUzQ@mail.gmail.com> <20141201184749.0fd67b62@natsu> <CAE8gLhnyTWjfTk-W+BHdfovV8pJH-yqo7joR+kf6vgs1FU00hw@mail.gmail.com> <CAH-HCWWZ4FXHtb42dVOaKtLzmndc=e_LAqrufUZRt36CD_g34g@mail.gmail.com>
In-Reply-To: <CAH-HCWWZ4FXHtb42dVOaKtLzmndc=e_LAqrufUZRt36CD_g34g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2014 08:40 AM, Shriramana Sharma wrote:
> IIUC you can only specify RO while creating but you can always cheaply
> create a RW snapshot of an RO one or an RO snapshot of an RW one...

You can turn ReadOnly status on and off (er. "true" and "false") with 
btrfs property get/set ro=true/false /path/to/subvolume



