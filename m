From: Waxhead <waxhead@online.no>
Subject: Will BTRFS repair or restore data if corrupted?
Date: Thu, 26 Jan 2012 00:27:57 +0100
Message-ID: <4F208FFD.4020508@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

 From what I have read BTRFS does replace a bad copy of data with a 
known good copy (if it has one). Will BTRFS try to repair the corrupt 
data or will it simply silently restore the data without the user 
knowing that a file has been "fixed"?

