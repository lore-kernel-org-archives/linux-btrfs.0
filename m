Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f194.google.com ([209.85.223.194]:35817 "EHLO
	mail-ie0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3F0KYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 06:24:49 -0400
Received: by mail-ie0-f194.google.com with SMTP id 9so438094iec.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 03:24:48 -0700 (PDT)
MIME-Version: 1.0
From: Kelvin <kelvin9302104@gmail.com>
Date: Thu, 27 Jun 2013 18:24:28 +0800
Message-ID: <CAFwaWH=iuaq2W05GrpitARq3L9w+ZNGPkC1C4p=Bd0AP6p84FQ@mail.gmail.com>
Subject: Transparent Tagging?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

We now have several desktop search engines. We can get what we want in
the hard disk easily. For example, when we are going to search for
songs, we can search for the files with suffix '.mp3', '.wav' and
something else. Isn't it very convenient?

However, this is not enough in some situations. For example, I want to
store a piece of homework about programming. It is obviously
impossible to put it in a well-named directory. I can only put it in
either dir called 'Programming' or 'Homework'. When I want to search
for all programming homework, what can I do? It is not necessary the
homework contains source codes. So, I cannot just search for the files
with suffix like '.cpp'. Also, if I search for all source codes, the
source codes which are not of homework will appear as well. The only
way to solve this problem is tagging.

It seems that there are some tagging systems, but they are not native
for the filesystem. It means that when we read the filesystem from an
OS without that system installed, everything will be in a mess (or we
can arrange the files in traditional way as well, but this is
inconvenient). Also, we need to manage the files through the utilities
provided, and this is not convenient.

The main point is here:
I think a transparent tagging system should be one of the features of
Btrfs. We can provide a userspace program. Using it, we can simulate a
directory in a partition. For example, we simulate a directory called
'Programming'. When we put something in that directory, the file will
be automatically tagged with 'Programming'. Also, the files appearing
in that directory mean they have the tag of 'Programming'. We can also
simulate a directory called 'Homework' in 'Programming'. The files in
'Programming->Homework' will have BOTH 'Programming' and 'Homework'
tagged. It would be easy to construct the following directory
structure: http://db.tt/bUr1WLrU

but we cannot construct the above directory structure in traditional
way. With the tagging function, the files appearing in
'Programming->Homework' will also appear in 'Programming', 'Homework'
and 'Homework->Programming'. Also, the files in
'Programming->Electronic Books' will also appear in 'Electronic Books'
and 'Electronic Books->Programming'. When we want to search for all
homework, we can go to 'Homework'. When we want to search for homework
about computer vision, we can go to 'Programming->Computer
Vision->Homework'. *A file can have more than one properties and
appears in more than one 'directories'.* **And this is transparent to
users!** Users can manage the files as usual. When the user removes a
file in a directory, it means that the file is untagged with the
corresponding tag, until all tags are removed.

(I guess that) this can actually be done by hard links. But I am not
sure whether the above suggestions are practical. (or is there any
identical alternatives?) Thanks for your patient for reading the
email!
