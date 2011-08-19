From: Anand Jain <Anand.Jain@oracle.com>
Subject: git resources
Date: Fri, 19 Aug 2011 15:09:21 +0800
Message-ID: <4E4E0C21.1010207@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

  There are quite a number of contents on the internet talking
  about git. (a problem in my case).
  Since I just need one good providing steps for what we are
  doing here..
   ---
    clone mainline
    clone btrfs (or some other)
    merge
     (make menuconfig, make, make modules_install, make install)
    make change(s)
    generate patch(s)
    setup for thunderbird send-email setup
    send-mail with the patches in the body
    make change(s) again
    generate patch(s) again
    send-mail

    pull the newer official release when released.

    apply the patch
   ---

  any idea what can help ?  Appreciate your time.

  (When we have this I shall update the btrfs wiki)

Thanks, Anand


