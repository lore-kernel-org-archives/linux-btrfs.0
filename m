Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33744 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbbLHCSv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 21:18:51 -0500
Received: by qgea14 with SMTP id a14so5435929qge.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Dec 2015 18:18:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151207153339.GF4227@twin.jikos.cz>
References: <1449207447-1203-1-git-send-email-naota@elisp.net>
 <1449207447-1203-2-git-send-email-naota@elisp.net> <20151207153339.GF4227@twin.jikos.cz>
From: Naohiro Aota <naota@elisp.net>
Date: Tue, 8 Dec 2015 11:18:31 +0900
Message-ID: <CAEe67=9D002VpFp32_dNs=GQ0GmErbgmvVRQeVvVU_VLS_6BkQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] btrfs-progs: test: umount if confirmation failed
To: David Sterba <dsterba@suse.cz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Naohiro Aota <naota@elisp.net>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 8, 2015 at 12:33 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Dec 04, 2015 at 02:37:25PM +0900, Naohiro Aota wrote:
>> When a check in check_inode() failed, the test should umount test target
>> file system. This commit add clean up umount line in failure path.
>
> The lack of cleanup after failed tests is intentional (exceptions
> possible). The tests are supposed to do cleanup if they pass but if they
> fail the test environment could be examined. In case of more complex
> setups (loop devices, dm devices) it's some work to set it up again.
>
> We could add an optional per-test script cleanup.sh that does the
> cleanup on demand (and is also run from tests/clean-tests.sh).

I see.
Well, I overlooked the README.md stating about clean-tests.sh...
