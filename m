Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33584 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbbCUR4N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Mar 2015 13:56:13 -0400
Received: by iecvj10 with SMTP id vj10so10748515iec.0
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Mar 2015 10:56:12 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 21 Mar 2015 18:56:12 +0100
Message-ID: <CA+4EQ5cL53dS5k8fPNauT1fPGaYXjKBSzo7jTt1nz5p=w+c_SQ@mail.gmail.com>
Subject: New tool to recursive compress / decompress of files
From: Petr Bena <benapetr@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I like the compress feature, but unlike NTFS, compressing files in
btrfs is not so simple. Just changing the flags using chattr will not
compress anything, only newly written data would be.

For this reason I decided to create a new tool that makes this simple,
you can find it here: https://github.com/benapetr/compress

It's very simple to use, for example to compress whole folder, you would do

compress -rv <folder_name>

the tool would recursively scan the folder, change all folders to +c
and copy all files, preserving attributes to a temporary file within
folder, then removes the original and move the copied, now fully
compressed file back.

It's written in python despite I loathe it (I am a C++ programmer),
because most of people love it for some reason, any because this would
make it more simple for people to deploy it and modify it.

The tool right now is in early alpha stage, probably full of bugs, I
made it few hours ago, but I would like to hear any feedback, whether
there would be any use for such a tool, feature requests etc :)

Thanks
