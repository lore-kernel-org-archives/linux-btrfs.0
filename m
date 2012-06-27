Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56811 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab2F0BzV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 21:55:21 -0400
Received: by obbuo13 with SMTP id uo13so740781obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 18:55:21 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 26 Jun 2012 20:55:20 -0500
Message-ID: <CAFwScO_ENB2tDKpXozCqz09PjH6sCRvDCB-Pr2XJSy2HTerwFQ@mail.gmail.com>
Subject: waiting for deferred cleanup operations
From: David Nicol <davidnicol@gmail.com>
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've noticed that the patches I posted here two years ago about an
ioctl to allow userspace to wait for deferred ops to complete aren't
included in the "has all patches posted to mailing list" git repo. Is
this an oversight or is there a problem with the proposed architecture
or implementation?

The proposed architecture is, there is an IOCTL to wait for deferred
activity to complete, and it takes a flag field listing possible
deferred activities that are being waited for. Only one was defined in
the submitted patch, to wait for completion of removal of dead trees,
with the hope that future deferred things would register a bit with
the ...

The whole picture is in the introduction to the last submitted version
of the patch,
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/8668

Is the patch as seen there good, and were I to update it to apply
against current source would there
be any problem with tracking it for mainstream inclusion?


David Nicol

-- 
Run it up the flagpole and see who salutes it
