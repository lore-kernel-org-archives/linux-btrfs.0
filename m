Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37923 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab3GPQzy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 12:55:54 -0400
Received: by mail-oa0-f47.google.com with SMTP id m1so1169707oag.34
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jul 2013 09:55:54 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Jul 2013 18:55:54 +0200
Message-ID: <CAG7ytityYnSO_i5fCRDOYyzAcx5YzGqj2MgK4bMSmKXuwxqw1w@mail.gmail.com>
Subject: btrfsck disk explenation
From: Gert Cuykens <gert.cuykens@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a nice overview
https://btrfs.wiki.kernel.org/index.php/Data_Structures but does not
show how things work. Would be helpful if there was a presentation
that shows what happens when for example you copy a file to understand
the use of each tree better?

I don't understand what went wrong in which tree?

parent transid verify failed (transid in root tree?)
leaf parent key incorrect (fs tree?)
bad block (csum tree does not match block?)

And finally can this be fixt?

root@v7:/srv# btrfsck disk
parent transid verify failed on 30113792 wanted 13 found 35
parent transid verify failed on 30113792 wanted 13 found 35
parent transid verify failed on 30113792 wanted 13 found 35
parent transid verify failed on 30113792 wanted 13 found 35
Ignoring transid failure
checking extents
parent transid verify failed on 61681664 wanted 9 found 33
parent transid verify failed on 61681664 wanted 9 found 33
parent transid verify failed on 61681664 wanted 9 found 33
parent transid verify failed on 61681664 wanted 9 found 33
Ignoring transid failure
leaf parent key incorrect 61681664
parent transid verify failed on 61681664 wanted 9 found 33
Ignoring transid failure
leaf parent key incorrect 61681664
parent transid verify failed on 61681664 wanted 9 found 33
Ignoring transid failure
leaf parent key incorrect 61681664
leaf parent key incorrect 29593600
bad block 29593600
parent transid verify failed on 29933568 wanted 13 found 34
parent transid verify failed on 29933568 wanted 13 found 34
parent transid verify failed on 29933568 wanted 13 found 34
parent transid verify failed on 29933568 wanted 13 found 34
Ignoring transid failure
leaf parent key incorrect 29933568
parent transid verify failed on 62836736 wanted 9 found 33
parent transid verify failed on 62836736 wanted 9 found 33
parent transid verify failed on 62836736 wanted 9 found 33
parent transid verify failed on 62836736 wanted 9 found 33
Ignoring transid failure
parent transid verify failed on 29962240 wanted 13 found 34
parent transid verify failed on 29962240 wanted 13 found 34
parent transid verify failed on 29962240 wanted 13 found 34
parent transid verify failed on 29962240 wanted 13 found 34
Ignoring transid failure
leaf parent key incorrect 29962240
parent transid verify failed on 29962240 wanted 13 found 34
Ignoring transid failure
leaf parent key incorrect 29962240
parent transid verify failed on 29962240 wanted 13 found 34
Ignoring transid failure
leaf parent key incorrect 29962240
parent transid verify failed on 29962240 wanted 13 found 34
Ignoring transid failure
leaf parent key incorrect 29962240
parent transid verify failed on 29962240 wanted 13 found 34
Ignoring transid failure
leaf parent key incorrect 29962240
parent transid verify failed on 29962240 wanted 13 found 34
Ignoring transid failure
leaf parent key incorrect 29962240
leaf parent key incorrect 29483008
bad block 29483008
leaf parent key incorrect 29548544
bad block 29548544
leaf parent key incorrect 29560832
bad block 29560832
bad block 29573120
leaf parent key incorrect 29581312
bad block 29581312
leaf parent key incorrect 29630464
bad block 29630464
leaf parent key incorrect 29691904
bad block 29691904
parent transid verify failed on 29933568 wanted 13 found 34
Ignoring transid failure
leaf parent key incorrect 29777920
bad block 29777920
leaf parent key incorrect 29904896
bad block 29904896
leaf parent key incorrect 29917184
bad block 29917184
leaf parent key incorrect 29933568
bad block 29933568
parent transid verify failed on 29933568 wanted 13 found 34
Ignoring transid failure
leaf parent key incorrect 29962240
bad block 29962240
leaf parent key incorrect 29970432
bad block 29970432
leaf parent key incorrect 29974528
bad block 29974528
leaf parent key incorrect 30068736
bad block 30068736
btrfsck: btrfsck.c:1935: check_owner_ref: Assertion `!(rec->is_root)' failed.
Aborted (core dumped)
root@v7:/srv#
