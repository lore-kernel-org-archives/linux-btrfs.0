Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40642 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaGaXy5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 19:54:57 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so3447913wgh.23
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 16:54:56 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 1 Aug 2014 02:54:35 +0300
Message-ID: <CAGqmi747VW41DOPR-uev5cDaYtJ=FzzMCVfNNqtF7OUwB1jLjg@mail.gmail.com>
Subject: Btrfs offline deduplication
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good time of day.
I have several questions about data deduplication on btrfs.
Sorry if i ask stupid questions or waste you time %)

What about implementation of offline data deduplication? I don't see
any activity on this place, may be i need to ask a particular person?
Where the problem? May be a can i try to help (testing as example)?

I could be wrong, but as i understand btrfs store crc32 checksum one
per file, if this is true, may be make a sense to create small worker
for dedup files? Like worker for autodefrag?
With simple logic like:
if sum1 == sum2 && file_size1 == file_size2; then
if (bit_to_bit_identical(file1,2)); then merge(file1, file2);
This can be first attempt to implement per file offline dedup
What you think about it? could i be wrong? or this is a horrible crutch?
(as i understand it not change format of fs)

(bedup and other tools, its cool, but have several problem with these
tools and i think, what kernel implementation can work better).

-- 
Best regards,
Timofey.
