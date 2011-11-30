From: Phillip Susi <psusi@cfl.rr.com>
Subject: Resize command syntax wrong?
Date: Wed, 30 Nov 2011 13:47:10 -0500
Message-ID: <4ED67A2E.9080809@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently the resize command is under filesystem, and takes a path to the mounted filesystem.  This seems wrong to me.  Shouldn't it be under device, and take a path to a device to resize?  Otherwise, how can a resize operation when you have multiple devices make any sense?
