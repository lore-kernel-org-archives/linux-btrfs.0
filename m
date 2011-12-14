From: Wilfred van Velzen <wvvelzen@gmail.com>
Subject: What is best practice when partitioning a device that holds one or
 more btr-filesystems
Date: Wed, 14 Dec 2011 14:00:38 +0100
Message-ID: <CAKsPgxFAjsuCRRG0hGRmpau=cOcaA5EfZYfB3AXQ8N7nL3EBmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

What is best practice when partitioning a device that holds one or
more btr-filesystems

Do it the old fashioned way, and create a number of partitions
according to your needs? Or create one big btrfs partition and use
subvolumes where you would normally create different partitions?

What are the considerations for doing it either way?

-- 
Wilfred
