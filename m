From: Struan Bartlett <struan.bartlett@NewsNow.co.uk>
Subject: btrfs balancing start - and stop?
Date: Fri, 01 Apr 2011 12:14:50 +0100
Message-ID: <4D95B3AA.2090106@NewsNow.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

My company is testing btrfs (kernel 2.6.38) on a slave MySQL database 
server with a 195Gb filesystem (of which about 123Gb is used). So far, 
we're quite impressed with the performance. Our database loads are high, 
and if  filesystem performance wasn't good, MySQL replication wouldn't 
be able to keep up and the slave latency would begin to climb. This 
though, is generally not happening, which is good.

However, we recently tried running 'btrfs fi balance' on the filesystem, 
and found this deteriorated performance significantly, and the MySQL 
replication latency did begin to climb. Several hours later, with the 
btrfs-cleaner thread apparently still busy, and our replication latency 
running to a couple of hours, and no sign of the balancing operation 
finishing, we decided we needed to terminate the balancing operation, 
which we did by rebooting the server.

That, however, is suboptimal in a production environment, and so I've 
some questions.

1) Is the balancing operation expected to take many hours (or days?) on 
a filesystem such as this? Or are there known issues with the algorithm 
that are yet to be addressed?

2) Is it supposed to be desirable to run balancing operations 
periodically anyway? Our server is running on hardware mirrored disks, 
so our btrfs filesystem is simply created in spare space on the LVM 
volume group, using a single LV block device. Does balancing help 
improve performance/optimise free space in this setup anyway?

3) If there's an ioctl for launching a balancing operation, would it be 
an idea to add one for pausing a balancing operation? If balancing may 
take 'significant' lengths of time, and if it's intended that balancing 
be done periodically, it might be helpful if one could start balancing 
when loads are lower, and make sure one can stop them when resources are 
needed (in our case, when slave latency exceeds acceptable limits).

Kind regards

Struan Bartlett
CTO
NewsNow.co.uk


