Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:36519 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbbDXMIF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 08:08:05 -0400
Received: by qcpm10 with SMTP id m10so24306623qcp.3
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 05:08:04 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 Apr 2015 20:08:04 +0800
Message-ID: <CAPBX1xJsZ+spTHNLhq+vyHt_ex_wjPGoz6H8fsV3=faNJ0jJyw@mail.gmail.com>
Subject: btrfs/078 may got stuck in the __wait_on_atomic_t
From: George Wang <xuw2015@gmail.com>
To: dhowells@redhat.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I got stuck by btrfs/078 with 1 cpu(2 core) machine. And I notice
this patch maybe the
root cause of it.

commit cb65537ee1134d3cc55c1fa83952bc8eb1212833
Author: David Howells <dhowells@redhat.com>
Date:   Fri May 10 19:50:26 2013 +0100

    Add wait_on_atomic_t() and wake_up_atomic_t()
<snip>
+/*
+ * To allow interruptible waiting and asynchronous (i.e. nonblocking) waiting,
+ * the actions of __wait_on_atomic_t() are permitted return codes.  Nonzero
+ * return codes halt waiting and return.
+ */
+static __sched
+int __wait_on_atomic_t(wait_queue_head_t *wq, struct wait_bit_queue *q,
+                      int (*action)(atomic_t *), unsigned mode)
+{
+       atomic_t *val;
+       int ret = 0;
+
+       do {
+               prepare_to_wait(wq, &q->wait, mode);
+               val = q->key.flags;
+               if (atomic_read(val) == 0)
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^here,
is this judge ok? if the val not 0,

the most thing we want to do is schedule.
+                       ret = (*action)(val);
+       } while (!ret && atomic_read(val) != 0);
+       finish_wait(wq, &q->wait);
+       return ret;
+}

Thanks,
George
