From: mp3geek <mp3geek@gmail.com>
Subject: compression performance/scalability
Date: Thu, 16 Apr 2009 01:44:56 +1200
Message-ID: <e6ac15e50904150644p5f768abdoddbef88c5aff31c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm using btrfs (from 2.6.29.1) on my mythtv box, and I've found
issues recording 2 channels with compression enabled. (2 seperate
DVB-S cards, recording 2 seperate channels at the same time). One
recording will be fine, but the other recording will be broken.. file
is damaged and basically unplayable. Seems better when compression
isn't enabled when saving 2 streams at the same time, both files
record fine.. will the performance improve in the upcoming 2.6.30?
