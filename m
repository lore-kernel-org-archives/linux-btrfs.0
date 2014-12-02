Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:53178 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaLBPSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 10:18:09 -0500
Received: by mail-qc0-f179.google.com with SMTP id c9so9325176qcz.24
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 07:18:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547D663A.3020201@jp.fujitsu.com>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <547D663A.3020201@jp.fujitsu.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Tue, 2 Dec 2014 20:47:47 +0530
Message-ID: <CAH-HCWV8upw8prPvCiJcpL2NRmuiWaAM+5ZEayD3OoEZrcsyaw@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 2, 2014 at 12:41 PM, Satoru Takeuchi
<takeuchi_satoru@jp.fujitsu.com> wrote:
>
> Snapper can automatically take a snapshot just before
> taking/deleting snapshots. So, if you delete a snapshot
> by mistake, it's still alive.

Sorta contradicts the whole point of deleting a snapshot, no? Or is it
some sort of trash vs (real) delete mechanism?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
