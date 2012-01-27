From: Wes <anomaly256@gmail.com>
Subject: btrfs filesystem df command oddly named?
Date: Fri, 27 Jan 2012 12:11:34 +1100
Message-ID: <CAHH42ivUik8NeT=h-AHQ9WwTZmpuN7BqyeN=ZNHM8RpjKu+-mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Just wondering,

Why is this command called 'df' when it reports total space and used
space but not free space?  Wouldn't this be more aptly named 'btrfs
filesystem du'  ?
It's been my understanding that traditionally 'df' has been to display
free space remaining (as well as total available and used, but with
the focus being on free space.  The 'df' man page indicates this as
well.)
