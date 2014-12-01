Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:57783 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaLANTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 08:19:44 -0500
Received: by mail-qg0-f44.google.com with SMTP id z60so7612190qgd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 05:19:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547C6922.6030206@gmail.com>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <20141130042306.GE8916@merlins.org> <547C6922.6030206@gmail.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Mon, 1 Dec 2014 18:49:23 +0530
Message-ID: <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Marc MERLIN <marc@merlins.org>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 6:42 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> We might want to consider adding an option to btrfs subvol del to ask for
> confirmation (or make it do so by default and add an option to disable
> asking for confirmation).

I already reported: https://bugzilla.kernel.org/show_bug.cgi?id=89091.
As I requested there, I prefer for confirmation by default and -f to
force otherwise, rather than behaviour of rm which requires -i to ask
confirmation.

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
