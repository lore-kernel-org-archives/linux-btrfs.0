Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50758 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030504AbaGRO1v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 10:27:51 -0400
Received: by mail-qa0-f51.google.com with SMTP id k15so3016488qaq.24
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 07:27:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1483007.OXNgJN24dh@xev>
References: <1405627978.2630.39.camel@s-Air> <e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
 <1405688218.3085.16.camel@s-Air> <1483007.OXNgJN24dh@xev>
From: Mike Hartman <mike@hartmanipulation.com>
Date: Fri, 18 Jul 2014 10:27:30 -0400
Message-ID: <CAB=7dhkcbfGrwSwq=7f_ML-DjPZY56VX08_Xz15MSG_4ygDk7A@mail.gmail.com>
Subject: Re: Questions on incremental backups
To: russell@coker.com.au
Cc: Sam Bull <sam.hacking@sent.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> And, finally, nobody has mentioned on the possibility of merging
>> multiple snapshots into a single snapshot. Would this be possible, to
>> create a snapshot that contains the most recent version of each file
>> present across all of the snapshots (including files which may be
>> present in only one of the snapshots)?
>
> There is no btrfs functionality for that.  But I'm sure you could do something
> with standard Unix utilities and copying files around.

You could probably use UnionFS or one of the alternatives to get a
merged view of a group of snapshots. You could then copy that merged
view and delete the original snapshots. I'm not sure if there's
anything special you have to do metadata-wise to turn that merged view
into something btrfs would still recognize as a snapshot though.
