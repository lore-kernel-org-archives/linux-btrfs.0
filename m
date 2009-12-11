From: Hu Ruihuan <specter118@gmail.com>
Subject: a question about btrfs_writepage
Date: Fri, 11 Dec 2009 19:56:42 +0800
Message-ID: <713d0d430912110356t3ed75c22u3b73fe2a19ed162a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?GB2312?B?uvrI8Lu4?= <specter118@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
  I am puzzled about a question, everytime when btrfs_writepage is
called, whethe the noeds in every levels of the fs tree will be
updated. This is the case as I read in the code, but if this case,
whether it will give rise to the low efficiency?
   Thanks!
