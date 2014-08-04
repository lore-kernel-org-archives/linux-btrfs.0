Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:53829 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaHDJ4r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 05:56:47 -0400
Received: by mail-vc0-f171.google.com with SMTP id hq11so10623782vcb.30
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 02:56:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <17833067.mzxAL4oqZq@quad>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
	<53DEE40C.6020403@cn.fujitsu.com>
	<CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
	<17833067.mzxAL4oqZq@quad>
Date: Mon, 4 Aug 2014 11:56:46 +0200
Message-ID: <CAFvQSYRtZZz00u5fg8h0bjT-W67URtNMqh6F7SZxgZVYXNyR8Q@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

> Hmm, it shouldn't be, the ENOSPC issues are well known and have been discussed
> here for years.

Which doesn't protect the *average* user from running into issues like this.
Just because it has been discussed, doesn't mean nothing can/should be
done about it ;)

However, as I am only a user too and can't contribute in terms of
code, I keep patient and observe how btrfs is evolving.
One day or another, the ENOSPC issues will get fixed or worked arround,

Regards, Clemens
