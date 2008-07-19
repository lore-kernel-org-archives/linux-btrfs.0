From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: single disk reed solomon codes
Date: Sat, 19 Jul 2008 15:21:40 +0300
Message-ID: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Since btrfs is someday going to be the default FS for Linux, and will
be on so many single disk PCs and laptops, I was thinking it should be
a good idea to insert some redundancy in single disk deployments. Of
course it can help with disk failures, since it's obviously a "single"
disk, but it can help with bit-rot, and with hardware sector read
errors. To get that we'd need to implement some kind of forward error
correction, possibly reed solomon code. I am not sure why no
filesystem seems to implement such scheme, although I believe at the
hardware level, such schemes are being used (so the idea is
applicable) ?
Not that I am an expert on such matters, but I thought I'd drop that
suggestion here, maybe at least I'll know why no one else seems to do
that
Regards
